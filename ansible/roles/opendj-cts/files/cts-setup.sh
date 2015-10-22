#!/usr/bin/env bash
# Prepare OpenDJ for CTS.  A variant of the script that is in the Admin guide
#
# copyright (C) 2014 ForgeRock AS
#
# cts-setup.sh: This script installs and configures an external CTS data store.
#

# Reset the tmp folder
T=/tmp/ldif
rm -rf $T
mkdir $T


# Environment variables. Override these to change the defaults
#
# Where to find template LDIF files for CTS.
# These are included when OpenAM is installed.
LDIF_DIR="${LDIF_DIR:=$HOME/openam/ldif/sfha}"

# Dir Manager
DIR_MGR="${DIR_MGR:=cn=Directory Manager}"
PASSWORD="${PASSWORD:=Passwr0d}"

# DJ  ports. Pick ones that are not likely to collide with an existing instance
ADMIN_PORT="${ADMIN_PORT:=2444}"
JMX_PORT="${JMX_PORT:=2689}"
LDAPS_PORT="${LDAPS_PORT:=2636}"
LDAP_PORT="${LDAP_PORT:=2389}"

# Hostname
DJ_HOSTNAME="${DJ_HOSTNAME:=opendj}"

# Root DN for CTS
CTS_DN="${CTS_DN:=dc=cts,dc=example,dc=com}"

# OpenDJ directory location. If this does not exist, the script will attempt to
# Unzip a new copy of the DJ bits
DJ_DIR="${DJ_DIR:=opendj}"

# zip of OpenDJ Distro
DJ_ZIP="${DJ_ZIP:=OpenDJ-2.6.2.zip}"


if [ ! -d "$DJ_DIR" ]; then
echo "OpenDJ does not exist. Will attempt to create instance"

# Create a properties file for the OpenDJ install
cat > $T/setup.props <<EOF
# Sample properties file to set up the OpenDJ directory server
hostname                      = $DJ_HOSTNAME
ldapPort                      = $LDAP_PORT
generateSelfSignedCertificate = true
enableStartTLS                = true
ldapsPort                     = $LDAPS_PORT
jmxPort                       = $JMX_PORT
adminConnectorPort            = $ADMIN_PORT
rootUserDN                    = $DIR_MGR
rootUserPassword              = $PASSWORD
##baseDN                      = dc=example,dc=com
##ldifFile                    = /path/to/Example.ldif
##sampleData                  =

EOF


echo "... Unpacking OpenDJ and installing ..."
unzip "$DJ_ZIP"
cd "./$DJ_DIR"
./setup --cli --propertiesFilePath $T/setup.props --acceptLicense --no-prompt
cd ..

fi

# At this point DJ should be installed
cd "$DJ_DIR"

echo "Attempting to start OpenDJ. If it is already running ignore any error message"
./bin/start-ds



# Create the CTS base dn and ACIs entries and write them to a file
# Linefeeds have been added for publication purposes.
cat > $T/add-cts-entries.ldif <<EOF
dn: $CTS_DN
objectclass: top
objectclass: domain
dc: cts
aci: (targetattr="*")(version 3.0;acl "Allow entry search";
 allow (search, read)(userdn = "ldap:///uid=openam,ou=admins,$CTS_DN");)
aci: (targetattr="*")(version 3.0;acl "Modify config entry";
 allow (write)(userdn = "ldap:///uid=openam,ou=admins,$CTS_DN");)
aci: (targetcontrol="2.16.840.1.113730.3.4.3")
 (version 3.0;acl "Allow persistent search";
 allow (search, read)(userdn = "ldap:///uid=openam,ou=admins,$CTS_DN");)
aci: (version 3.0;acl "Add config entry"; allow (add)(userdn = "ldap:///uid=openam,ou=admins,$CTS_DN");)
aci: (version 3.0;acl "Delete config entry"; allow (delete)(userdn = "ldap:///uid=openam,ou=admins,$CTS_DN");)

dn: ou=admins,$CTS_DN
objectclass: top
objectclass: organizationalUnit
ou: admins

dn: uid=openam,ou=admins,$CTS_DN
objectclass: top
objectclass: person
objectclass: organizationalPerson
objectclass: inetOrgPerson
cn: openam
sn: openam
uid: openam
userPassword: secret12
ds-privilege-name: subentry-write
ds-privilege-name: update-schema
EOF


# Create the CTS Backend
echo ""
echo "... Creating backend ..."
echo ""
bin/dsconfig create-backend \
--backend-name cts-store \
--set base-dn:"$CTS_DN" \
--set enabled:true \
--type local-db \
--port $ADMIN_PORT \
--bindDN "$DIR_MGR" \
--bindPassword $PASSWORD \
--trustAll \
--no-prompt
echo "Backend created"

# Verify Backend
#bin/dsconfig list-backends \
#--port $ADMIN_PORT \
#--bindDN "$DIR_MGR" \
#--bindPassword $PASSWORD \
#--trustAll \
#--no-prompt

# Add the Base DN and ACIs
echo ""
echo "...Adding Base DN and ACIs..."
echo ""
bin/ldapmodify \
--port $ADMIN_PORT \
--bindDN "$DIR_MGR" \
--bindPassword $PASSWORD \
--defaultAdd \
--filename $T/add-cts-entries.ldif \
--useSSL \
--trustAll
echo "BaseDN and ACIs added."

# Verify BaseDN and ACIs
bin/ldapsearch --port $ADMIN_PORT --bindDN "$DIR_MGR" --bindPassword $PASSWORD \
 --baseDN "$CTS_DN" --searchscope sub --useSSL --trustAll  "(objectclass=*)"



# Add the Admin Global ACI
echo ""
echo "...Adding Admin Global ACIs..."
echo ""
bin/dsconfig set-access-control-handler-prop \
--add global-aci:'(target = "ldap:///cn=schema")(targetattr = "attributeTypes || objectClasses")(version 3.0; acl "Modify schema"; allow (write) userdn = "ldap:///uid=openam,ou=admins,'"${CTS_DN}"'";)' \
--port $ADMIN_PORT \
--bindDN "$DIR_MGR" \
--bindPassword $PASSWORD \
--trustAll \
--no-prompt
echo "Global ACI added."


# Verify Global ACI
bin/dsconfig get-access-control-handler-prop --property global-aci --port $ADMIN_PORT \
 --bindDN "$DIR_MGR" --bindPassword $PASSWORD -X -n

# Copy the Schema, Indexes, and Container files for CTS
echo ""
echo "... Begin copying schema, indexes, and container ..."
cp $LDIF_DIR/cts-add-schema.ldif $T/cts-add-schema.ldif
cat $LDIF_DIR/cts-indices.ldif | sed -e 's/@DB_NAME@/cts-store/' > $T/cts-indices.ldif
cat $LDIF_DIR/cts-container.ldif | sed -e \
 "s/@SM_CONFIG_ROOT_SUFFIX@/$CTS_DN/" > $T/cts-container.ldif
echo "Schema, index, and container files copied."

# Add the Schema Files
echo ""
echo "... Adding CTS Schema ..."
bin/ldapmodify --port $ADMIN_PORT --bindDN "$DIR_MGR" --bindPassword $PASSWORD \
 --fileName $T/cts-add-schema.ldif --useSSL --trustAll

# Add the CTS Indexes
echo ""
echo "... Adding CTS Indexes ..."
bin/ldapmodify --port $ADMIN_PORT --bindDN "$DIR_MGR" --bindPassword $PASSWORD --defaultAdd \
 --fileName $T/cts-indices.ldif --useSSL --trustAll

# Add the CTS Container Files
echo ""
echo "... Adding CTS Container ..."
bin/ldapmodify --port $ADMIN_PORT --bindDN "$DIR_MGR" --bindPassword "$PASSWORD" --defaultAdd \
 --fileName $T/cts-container.ldif --useSSL --trustAll

# Rebuild the Indexes
echo ""
echo "... Rebuilding Index ..."
bin/rebuild-index --port $ADMIN_PORT --bindDN "$DIR_MGR" --bindPassword "$PASSWORD" \
 --baseDN "$CTS_DN" --rebuildALL --start 0 --trustAll

# Verify the Indexes
echo ""
echo "... Verifying Index ..."
bin/verify-index --baseDN "$CTS_DN"

echo ""
echo "Your CTS External Store has been successfully installed and configured."
exit 0
