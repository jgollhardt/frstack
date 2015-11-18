# Makefile

.PHONY: push container all

#TAG = dev
#PROJECT=frstack-1077
PREFIX = gcr.io/$(PROJECT)

all: push

container: 
	docker build -t $(PREFIX):$(TAG) .

push: container
	gcloud docker push $(PREFIX)/ssoconfig:$(TAG)

