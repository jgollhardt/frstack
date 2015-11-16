# Makefile for the Docker image gcr.io/kube-ui/kube-ui
# MAINTAINER: Tim St. Clair <stclair@google.com>
# If you update this image please check the tag value before pushing.

.PHONY: all container push clean download ssoadm openam

# Keep this at dev, so no one accidentally blows away the latest published version.
TAG = dev # current version: v1
PROJECT=frstack-1077
PREFIX = gcr.io/$(PROJECT)

all: download ssoadm openam  pushssoadm pusham

download: 
	../bin/getnightly.sh 

ssoadm:
	cp staging/ssoadmintools.zip ssoadm
	docker build -t $(PREFIX)/ssoadm:$(TAG) ssoadm

openam:
	cp staging/openam.war openam
	docker build -t $(PREFIX)/openam:$(TAG) openam

pushssoadm: 
	gcloud docker push $(PREFIX)/ssoadm:$(TAG)

pusham: 
	gcloud docker push $(PREFIX)/openam:$(TAG)

clean:
	rm -fr staging 
	rm openam/*war
	rm ssoadm/*zip 


