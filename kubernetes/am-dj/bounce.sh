#!/bin/sh
# Bounce all except service (so we dont lose our IP). Used for testing


SVC="amconfig openam-controller opendj-controller ssoconfig"

for svc in $SVC
do
  kubectl delete -f $svc.yaml
done

sleep 10


for svc in $SVC
do
  kubectl create -f $svc.yaml
done
