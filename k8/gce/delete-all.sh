#!/usr/bin/env bash

export ZONE=us-central1-a


# Delete all - but dont stop the cluster

# Use kubectl locally
kubectl  config use-context gke_forgerockdemo_us-central1-a_openam


kubectl delete -f openam-service-a.yaml
kubectl delete -f openam-service-b.yaml

kubectl delete -f openam-service.yaml


kubectl delete -f opendj-controller.yaml
kubectl delete -f opendj-service.yaml

kubectl delete -f openam-controller.yaml
kubectl delete -f openam-controllerb.yaml


echo This script does not delete the cluster! To delete the cluster use this:
echo gcloud alpha container clusters delete openam --zone $ZONE

