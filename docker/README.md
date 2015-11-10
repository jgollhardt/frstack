# Experimental: Running OpenAM in Docker / Kubernetes (k8)



What is here:

haproxy/ - an haproxy Docker image, but also a script to run haproxy in from your laptop.
   For running on k8 you probably dont need haproxy - since you can use the GCE load balancer.

ssoconfig/
   A Dockerfile for running the OpenAM configurator tool




There are couple of other Docker images that are used - they are being built on the Docker hub,
   and the source for them is at https://github.com/ForgeRock/docker

