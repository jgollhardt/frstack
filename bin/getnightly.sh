#!/bin/bash
#
# Downloads nightly ForgeRock builds using from the maven artifactory repo
#
# Vagrant guests should have this staging directory mounted locally.
# This script leaves the product names as generic (no release in the name), but creates a RELEASE file
# with all of the version info. It is suggested to copy this RELEASE file into the guest to have a record
# of the binary version numbers.

# Directory to download to
dir=./staging/


# These are the items you can download. tomcat, apache,jetty refer to agents
items="openam ssoadm openidm openig opendj apache tomcat jetty"

# If no args are supplied - all of the above assets are downloaded. If args are supplied
# just the named items are downloaded.
if [ $# -gt 0 ]; then
   items=$*
fi

# Top level variables -edit these as appropriate

MVN_SNAPSHOT="http://maven.forgerock.org/repo/snapshots"

AM_VERSION="14.0.0-SNAPSHOT"
# note trailing / is needed
AM_SERVER_PATH="$MVN_SNAPSHOT/org/forgerock/openam/openam-server/$AM_VERSION/"
AM_SSOTOOLS_PATH="$MVN_SNAPSHOT/org/forgerock/openam/openam-distribution-ssoadmintools/$AM_VERSION/"

IDM_VERSION="4.1.0-SNAPSHOT"
IDM_PATH="$MVN_SNAPSHOT/org/forgerock/openidm/openidm-zip/$IDM_VERSION/"

IG_VERSION="4.0.0-SNAPSHOT"
IG_PATH="$MVN_SNAPSHOT/org/forgerock/openig/openig-war/$IG_VERSION/"

DJ_VERSION="4.0.0-SNAPSHOT"
DJ_PATH="$MVN_SNAPSHOT/org/forgerock/opendj/opendj-server-legacy/$DJ_VERSION/"

# Default GNU Grep to use Perl regex
GREP="grep -o -P"
# Mac used BSD grep
if [ "`uname`" == "Darwin" ]; then
GREP="egrep -o"
fi

# If you want to force a fresh download uncomment this
# rm -fr $dir

mkdir $dir
cd $dir


# Download a file at URL $1 name it $2
download_file() {
   if [ ! -f $2 ]; then
      echo $1 >>RELEASE
      echo downloading $RELEASE
      echo $1 | xargs curl -o $2
   else
      # File already downloaded. log this to the release file and to the console
      echo "File $2 exists - Skipping. Delete this file if you really want to download a fresh version" >>RELEASE
      echo $2 already downloaded. Skipping
   fi
}

# function to parse a filename from an http dir listing path $1 with extension $2 (e.g. zip war etc.)
grep_file() {
   x=`curl -s $1 | $GREP  \".*?\.$2\" | tr -d \"`
   echo $1$x
}


# TOOD: Improve agent download process

# Apache Agent
# This script is quite specfific to Linux 64 bit VMs. You may want to make it more generic...
# TODO Have not quite figured out to scrape the Web Agent screen yet.
apache(){
APACHE="apache_v24_Linux_64_agent_4.0.0-SNAPSHOT.zip"
apache="http://download.forgerock.org/downloads/openam/webagents/nightly/Linux/$APACHE"
download_file $apache  apache_v24_agent.zip
}

# Tomcat JEE agent
tomcat(){
tomcat=`curl -s https://forgerock.org/downloads/openam-builds/ | grep -o "http://.*tomcat_v6.*\.zip" | head -1`
download_file $tomcat tomcat_agent.zip
}

# Jetty
jetty () {
jetty=`curl -s https://forgerock.org/downloads/openam-builds/ | grep -o "http://.*jetty_v7.*\.zip" | head -1`
download_file $jetty jetty_agent.zip
}


echo  "#Starting download at `date`" > RELEASE

for item in $items; do
   case $item in
   openam)  download_file `grep_file $AM_SERVER_PATH war` openam.war;;
   ssoadm)  download_file `grep_file $AM_SSOTOOLS_PATH zip`  ssoadmintools.zip;;
   openidm) download_file `grep_file $IDM_PATH zip` openidm.zip;;
   openig)  download_file `grep_file $IG_PATH war` openig.war;;
   opendj)  download_file `grep_file $DJ_PATH zip` opendj.zip;;
   apache)  apache;;
   tomcat)  tomcat;;
   jetty)   jetty;;
   *)    echo "Invalid download asset name $item"
   esac
done

echo "# Finished download at `date`" >> RELEASE
exit 0
