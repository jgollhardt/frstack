#!/bin/bash
# Script that downloads all nightly builds into a staging directory
# Vagrant guests should have this staging directory mounted locally.
# This script leaves the product names as generic (no release in the name), but creates a RELEASE file
# with all of the version info. It is suggest to copy this RELEASE file into the guest to have a record
# of which binaries got installed.


dir=./staging/

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
      echo "$2 exists - it looks like $1 already downloaded. Skipping" >>RELEASE
      echo $1 already downloaded. Skipping
   fi
}


echo  "#Starting download at `date`" > RELEASE

# OpenIDM
idm=`curl -s https://forgerock.org/downloads/openidm-builds/ | grep -o "http://.*\.zip" | head -1`
download_file $idm openidm.zip

# OpenIG
# Use egrep to get non greedy match to war file
ig=`curl -s https://forgerock.org/downloads/openig-builds/ | egrep -o  "http://.*?\.war"`
download_file $ig  openig.war


# opendj
dj=`curl -s https://forgerock.org/djs/opendjrel.js | grep -o "http://.*\.zip" | tail -1`
download_file $dj opendj.zip


# Get OpenAM war file
am=`curl -s http://download.forgerock.org/downloads/openam/openam_link.js | grep -o "http://.*\.war"`
download_file $am openam.war


# And SSO Admin tools
ssoadmin=`curl -s http://download.forgerock.org/downloads/openam/openam_link.js | grep -o "http://.*SSOAdminTools.*.zip"`
download_file $ssoadmin  ssoadmintools.zip

# Apache Agent
# This script is quite specfific to Linux 64 bit VMs. You may want to make it more generic...
# TODO Have not quite figured out to scrape the Web Agent screen yet.
APACHE="apache_v24_Linux_64_agent_4.0.0-SNAPSHOT.zip"
apache="http://download.forgerock.org/downloads/openam/webagents/nightly/Linux/$APACHE"
download_file $apache  apache_v24_agent.zip


# Tomcat JEE agent
tomcat=`curl -s https://forgerock.org/downloads/openam-builds/ | grep -o "http://.*tomcat_v6.*\.zip" | head -1`
download_file $tomcat tomcat_agent.zip

# Jetty
jetty=`curl -s https://forgerock.org/downloads/openam-builds/ | grep -o "http://.*jetty_v7.*\.zip" | head -1`
download_file $jetty jetty_agent.zip


echo "# Finished download at `date`" >> RELEASE