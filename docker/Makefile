# Makefile for the Docker image gcr.io/kube-ui/kube-ui
# MAINTAINER: Tim St. Clair <stclair@google.com>
# If you update this image please check the tag value before pushing.

.PHONY: all container push clean download ssoadm openam

# Keep this at dev, so no one accidentally blows away the latest published version.
TAG = dev # current version: v1
PROJECT=frstack-1077
PREFIX = gcr.io/$(PROJECT)

all: ssoadm

download: 
	../bin/getnightly.sh 

ssoadm:
	$(MAKE) -C ssoadm



