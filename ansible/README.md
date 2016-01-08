### Ansible Notes

The frstack is the main playbook and does most of the heavy lifting.

There is a work-in-progress playbook called ```fr_optional.yml``` which is where optional software
and configuration will go.

### Ansible ssh users

For Vagrant this is the 'vagrant' user. For AWS, 'ec2user', and
for Google Compute engine it will be the user account who created the VMs (your login id).


## Running on Google Compute Engine (GCE)

The gce.yml playbook will create a base Centos image on GCE. The image will be ready to run the frstack.yml playbook against.
This has not been tested in a while and probably needs to be updated.
