#!/bin/bash
# Commands to create PD disks needed right now for storing openam config
# Containers are ephemeral - so we need some way of storing
# The AM persistent state. This should be replaced over time
# with ENV vars passed to the AM image that auto-create the
# bootstrap and ~/openam

export ZONE=us-central1-f
MASTER=frstack
#k8s-openam-master

doit=echo

$doit gcloud compute disks create openam-disk-a --size 2GB  --zone $ZONE
$doit gcloud compute disks create openam-disk-b --size 2GB  --zone $ZONE

# attach to master node for initial format

$doit gcloud compute instances attach-disk $MASTER --disk openam-disk-a --zone $ZONE
$doit gcloud compute instances attach-disk $MASTER --disk openam-disk-b --zone $ZONE

# See https://cloud.google.com/compute/docs/disks/persistent-disks#attachdiskrunninginstance


# now deatach

echo When the disks are formatted detach:
echo gcloud compute instances detach-disk $MASTER --disk openam-disk-a --zone $ZONE
echo gcloud compute instances detach-disk $MASTER --disk openam-disk-b --zone $ZONE