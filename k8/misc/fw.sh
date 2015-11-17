#!/usr/bin/env bash

gcloud compute firewall-rules create kube-30301 --allow=tcp:30301

gcloud compute firewall-rules create kube-30284 --allow=tcp:30284


