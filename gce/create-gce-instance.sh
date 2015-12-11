#!/usr/bin/env bash
# Sample command to create a GCE instance for running frstack

gcloud compute --project "forgerockdemo" instances create "frstack" \ 
--zone "us-central1-f" --machine-type "n1-standard-2" --network "default" \
--no-restart-on-failure --maintenance-policy "TERMINATE" --preemptible --scopes \ 
"https://www.googleapis.com/auth/cloud.useraccounts.readonly", \
"https://www.googleapis.com/auth/devstorage.read_only", \
"https://www.googleapis.com/auth/logging.write", \
"https://www.googleapis.com/auth/monitoring.write" \
--tags "http-server" "https-server" \
--image  "https://www.googleapis.com/compute/v1/projects/centos-cloud/global/images/centos-7-v20151104" \
--boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "frstack"
