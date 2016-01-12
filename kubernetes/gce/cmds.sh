#!/usr/bin/env bash
# Some sample commands to cut n paste


# create cluster
export ZONE=us-central1-f
export CLUSTER_NAME=openam

gcloud beta container clusters create $CLUSTER_NAME --num-nodes 1 --machine-type  n1-standard-2 --zone $ZONE


# Use kubectl locally
kubectl  config use-context gke_forgerockdemo_us-central1-b_openam


# delete a cluster
echo to delete the cluster run
echo gcloud container clusters delete $CLUSTER_NAME  --zone $ZONE


# Sample commands to get pods, then exec into pod
kubectl get po
kubectl exec openam-a-u87ja  -i -t -- bash -il

