# Makefile for the Docker image gcr.io/kube-ui/kube-ui
# MAINTAINER: Tim St. Clair <stclair@google.com>
# If you update this image please check the tag value before pushing.

.PHONY: all container push clean download ssoadm openam ssoconfig

# Keep this at dev, so no one accidentally blows away the latest published version.
export TAG = dev 
export PROJECT=frstack-1077
export PREFIX = gcr.io/$(PROJECT)

all: ssoconfig

download: 
	../bin/getnightly.sh 

ssoadm:
	$(MAKE) -C ssoadm

ssoconfig: 
	$(MAKE) -C ssoconfig

