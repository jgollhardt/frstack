### Ansible Notes

The install is split into two top level playbooks. The first playbook (vagrant.xml) primes the environment required
for the main ForgeRock playbook (frstack.yml). Over time there will be an aws.yml playbook, a gce.yml, and so on.

The first playbook is responsible for installing a few base O/S packages and for create the "fr" forgerock user under
which the products will be installed.

The second playbook "frstack.yml" does most of the heavy lifting and completes the install.
The frstack.yml should be generic enough to run on any environment. This playbook is included from vagrant.yml .

There is a work-in-progress playbook called ```fr_optional.yml``` which is where optional software
and configuration will go.

### Ansible ssh users

For Vagrant this is the 'vagrant' user. For AWS, 'ec2user', and
for Google Compute engine it will be the user account who created the VMs (your login id).


## Running on Google Compute Engine (GCE)

The gce.yml playbook will create a base Centos image on GCE. The image will be ready to run the frstack.yml playbook against.
This has not been tested in a while and probably needs to be updated.

## Speeding up re-installs using a proxy server (NOT WORKING!!)

[Note: This does not reliably work right now - see below]

Edit group_vars/all and uncomment the proxy server configuration.  Ansible will use
the proxy when installing packages and when downloading zip files.

In theory using a proxy server should speed up reinstalls, but
I am finding that squid proxy does not work reliably with yum.
Fedora dynamically picks a rpm server which messes up squid caching
