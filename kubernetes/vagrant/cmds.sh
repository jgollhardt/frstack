#!/usr/bin/env bash

# Sample commands (replace pod name with real name)

# Switch to local vagrant cluster
kubectl  config use-context vagrant-k8


# Example: Bring up a shell in a container
kubectl exec -p openam-rhc70 -c openam -i -t -- bash -il

# Example: Show dns logs
kubectl log kube-dns-6968t skydns



# Create the openam controller
kubectl create -f openam-controller.yaml


# Delete all with label
kubectl delete pods,rc,services -l name=opendj


# Switch to local vagrant cluster
kubectl  config use-context vagrant-k8


# Example: Using context argument
kubectl --context=vagrant-k8 create -f openam-controller.yaml

