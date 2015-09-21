#!/usr/bin/env bash
# Get the nightly builds using maven

rm -fr ./staging
mkdir staging
mvn install  | tee ./staging/RELEASE
