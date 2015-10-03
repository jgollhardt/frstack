#!/usr/bin/env bash
# Get the nightly builds using maven
# This is an alternative to using the ../bin/getnightly.sh shell script

rm -fr ./staging
mkdir staging
mvn install  | tee ./staging/RELEASE
