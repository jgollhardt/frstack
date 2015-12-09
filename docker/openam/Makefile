# Makefile

.PHONY: push container all

all: push

container: 
	docker build -t $(PREFIX):$(TAG) .

push: container
	gcloud docker push $(PREFIX)/openam:$(TAG)

