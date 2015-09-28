# Running OpenAM / DJ on Kubernetes

Very much experimental..


# GCE directory
These files are used to create images on a Kubernetes.io cluster running on Google Container Engine (sometimes called
   GKE).

The create-all.sh script will create a cluster (2 nodes), and then provision the k8 replication controllers and services to run
OpenAM and OpenDJ



# Vagrant Directory

I have tested these using https://github.com/pires/kubernetes-vagrant-coreos-cluster - which runs
   the k8 cluster on VirtualBox / Vagrant.


# Ansible

The Ansible playbook openam.yml completes the cluster install by configuring OpenAM. The provision shell script calls
the ansible playbook openam.yml


# Operation

The k8 config files use  Docker images for OpenDJ and OpenAM to stand up a cluster of two OpenAM nodes and a single OpenDj server.

Once the cluster is ready, the OpenAM nodes will be running but need to be configured.

You will need to run
```
kubectl get services
```

To get the IP addresses of the load balancer (GCE). Add these to your /etc/hosts. Something like this:
```
146.148.46.60 opendj.example.com
146.148.91.129 openam.example.com
130.211.158.228 openam-a.example.com openam-svc-a
130.211.183.114 openam-b.example.com openam-svc-b
```

Then you can run ./provision - which will invoke the ansible playbook openam.yml to configure the two instances.

# Notes on GCE

See https://www.google.com/url?q=https%3A%2F%2Fgithub.com%2FGoogleCloudPlatform%2Fkubernetes%2Fissues%2F8673&sa=D&sntz=1&usg=AFQjCNGGTYFumFL21JDxfI-SNJqXHR2Tcw

You will need to login to GCE cloud console, find the Network load balancer target pool, and configure a health check
   for port 80.  Otherwise the LB will send traffic to both OpenAM nodes - which will cause issues.




