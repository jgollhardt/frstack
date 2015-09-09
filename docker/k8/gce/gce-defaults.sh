#!/usr/bin/env bash

# Source this to set GCE K8 params. This is if  you run on the "gce" provider
# If you are using GKE commands you dont need these

export NUM_MINIONS=1
export MASTER_DISK_SIZE=20GB
export MINION_DISK_SIZE=20GB

# todo: figure out --preemptive options

K8=~/tmp/kubernetes/