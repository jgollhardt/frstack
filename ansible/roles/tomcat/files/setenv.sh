#!/bin/sh
# Note that for JDK 8 max perm is no longer needed
export JAVA_OPTS="$JAVA_OPTS\
 -server\
 -Xms704m\
 -Xmx1024m\
 -XX:MaxPermSize=256m"
 