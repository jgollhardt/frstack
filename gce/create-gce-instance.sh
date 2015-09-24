#!/usr/bin/env bash
# Sample command to create a GCE instance for running frstack

gcloud compute --project "frstack-1077" instances create "instance-1" --zone "us-central1-f"  \
   --machine-type "n1-standard-2" --network "default" --no-restart-on-failure --maintenance-policy "TERMINATE"
   --preemptible --scopes "https://www.googleapis.com/auth/cloud-platform" \
   --tags "http-server" "https-server" "frstack" \
    --image "https://www.googleapis.com/compute/v1/projects/centos-cloud/global/images/centos-7-v20150915" \
    --boot-disk-size "15" --boot-disk-type "pd-standard"  \
    --boot-disk-device-name "instance-1"

