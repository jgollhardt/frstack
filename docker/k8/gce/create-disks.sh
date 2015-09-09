#!/bin/bash
# Commands to create PD disks needed right now for storing openam config
# Containers are ephemeral - so we need some way of storing
# The AM persistent state. This should be replaced over time
# with ENV vars passed to the AM image that auto-create the
# bootstrap and ~/openam

export ZONE=us-central1-b

gcloud compute disks create openam-disk-a --size 2GB  --zone $ZONE
gcloud compute disks create openam-disk-b --size 2GB  --zone $ZONE

# attach to master node for initial format

gcloud compute instances attach-disk k8s-openam-master --disk openam-disk-a --zone $ZONE
gcloud compute instances attach-disk k8s-openam-master --disk openam-disk-b --zone $ZONE

# See https://cloud.google.com/compute/docs/disks/persistent-disks#attachdiskrunninginstance


# now deatach

echo When the disks are formatted detach:
echo gcloud compute instances detach-disk k8s-openam-master --disk openam-disk-a --zone $ZONE
echo gcloud compute instances detach-disk k8s-openam-master --disk openam-disk-b --zone $ZONE