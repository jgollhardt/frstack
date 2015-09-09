#!/usr/bin/env bash

date
# Delete any existing cluster
#gcloud alpha container clusters -q delete openam

export ZONE=us-central1-b


gcloud beta container clusters create openam --num-nodes 1 --machine-type  n1-standard-2 --zone $ZONE


# Use kubectl locally
kubectl  config use-context gke_forgerockdemo_us-central1-b_openam

kubectl create -f opendj-controller.yaml
kubectl create -f opendj-service.yaml

kubectl create -f openam-controller.yaml
kubectl create -f openam-controllerb.yaml


kubectl create -f openam-service-a.yaml
kubectl create -f openam-service-b.yaml

kubectl create -f openam-service.yaml


kubectl get services

echo edit /etc/hosts and put in services for above
echo then cd .. and ./runans gce/openam.yaml


date

