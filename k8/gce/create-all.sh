#!/usr/bin/env bash

date
# Delete any existing cluster
#gcloud alpha container clusters -q delete openam


doit=echo

export ZONE=us-central1-f


$doit gcloud beta container clusters create openam --num-nodes 2 --machine-type  n1-standard-2 --zone $ZONE


# Use kubectl locally
#kubectl  config use-context gke_forgerockdemo_us-central1-f_openam

$doit kubectl create -f opendj-controller.yaml
$doit kubectl create -f opendj-service.yaml

$doit kubectl create -f openam-controller.yaml
$doit kubectl create -f openam-controllerb.yaml


# These are needed for ssoconfig so it can talk to each server individually
$doit kubectl create -f openam-service-a.yaml
$doit kubectl create -f openam-service-b.yaml

$doit kubectl create -f openam-service.yaml


$doit kubectl get services

echo edit /etc/hosts and put in services for above
#echo then cd .. and ./runans gce/openam.yaml


# This runs the ssoconfig docker container that configs two OpenAM instances
$doit kubectl create -f ssoconfig-pod.yaml
date

