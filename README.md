# Install the ForgeRock Open Identity Stack (OIS)
#

*NOTE: This currently works on Fedora using Vagrant. Google Compute Engine (GCE) and AWS are a
work in progress. Other combinations have not been tested.*


Installs the ForgeRock Open Identity Stack (OIS) on a Vagrant guest VM image.
Uses [Ansible](https://github.com/ansible/ansible) to automate the installation. This has been
tested using [Vagrant](http://www.vagrantup.com/), but with modification it should also work on AWS or GCE. 


## Installed products

This will configure a guest image to run the ForgeRock Open Identity (OIS) stack. After completion guest will
have the following configured:

* haproxy to route ports 80/443 to various backend services. A test SSL cert is installed
* openidm running on port 9090 (proxied at  http://openam.example.com/openidm  and /openidmui )
* opendj running on port 389. This is the user profile store.
* openam running on port 8080 (proxied at https://openam.example.com/openam)
* openig running on port 2080  (proxied at https://openam.example.com/openig/  Note  the trailing /!)
* Policy agents installed (but not configured) for Apache and tomcat

## Quick Start

* Install Ansible, VirtualBox and Vagrant. If you are on a
  mac you can install Ansible using 
  
  ```brew install ansible```

* Download all of the ForgeRock binaries to the staging directory: **vagrant/staging**. There
is a shell script provided **vagrant/getnightly.sh** that will auto download all of the nightly builds for you.
* Edit ansible/group_vars/all with any environment specific configuration.
* Execute the following:
```
cd vagrant
vagrant up
```

This may take a long time as the Vagrant VM must be downloaded. Be Patient!

If there are no errors from above you should be ready to test the VM.Put the IP address of the guest in your
hosts **/etc/hosts** file. The Vagrant image is configured to use a host only IP:

`192.168.56.11 openam.example.com openidm.example.com`

* Login to OpenAM at http://openam.example.com/openam  (amadmin/password)
* Login to OpenIDM at http://openidm.example.com/admin  (openidm-admin/openidm-admin)
* View the OpenIG landing page at http://openam.example.com/openig/  
* View the haproxy status page at https://openam.example.com/haproxy?stats
* View the default Apache landing page at https://openam.example.com/   (Currently protected  - so you will get a 403)
* ssh into the guest using `vagrant ssh` 
* Using an ldap browser (Apache Directory Studio, for example) you can browse the user store at openam.example.com:389,   
  cn=Directory Manager / password

Software is installed in the guest in the fr_home directory - which is /opt/ois.


## Shell scripts

Shell scripts are provided to re-run all or part of the provisioning process. For example,

```
./frstack
```

Will run the entire frstack.yml playbook. 

Ansible also supports the concept of "tags". If you want to run a subset of the playbook, provide a comma seperated value (no spaces) with a list of tags. For example:

```
cd vagrant
./frstack openam,openidm
```

Will run just those roles that pertain to OpenAM and OpenIDM

You can also re-run the vagrant ansible provisioner using:

```
vagrant provision
```
But note that this will not allow you to selectively provision using tags. This is essentially equivalent to runing ./frstack
with no tags.


## Staging files

For Vagrant installs, the "staging/" directory is mounted on the guest.


## The 'fr' ForgeRock user

The project runs an Ansible role called 'create-fr-user' that creates a ForgeRock user 'fr'. This user owns the directories and runs most of the JDKs for the stack.

An older version 
of this project used the 'fr' user for the ansible connection.  This is not longer used. Currently the project will
connect using the default user for the target environment. For Vagrant this is the 'vagrant' user. For AWS, 'ec2uesr', and
for Google Compute engine it will be the user account who created the VMs (your login id).

It may be handy to be able to ssh into the guest as the fr user:

```ssh fr@openam.example.com``` 

The create-fr-user role attempts to copy your ssh public key in ~/.ssh/id_rsa.pub (on your local host) to the guests /home/fr/.ssh/known_hosts. If you don't have
a public key in your ~.ssh directory create one following the instructions here: [https://help.github.com/articles/generating-ssh-keys/]



## Troubleshooting 

### SSH Issues

Ansible uses ssh to connect to the guest image. To debug connection issues you can use the -vvvv option when running the playbook. 
Edit the frstack script to set this variable (uncomment the DEBUG line).


## VM Services

The VM uses systemd to control all services. You can start / stop and get service status using 
the command systemctl:

```systemctl [start|stop|status|restart]  service```

Where service is one of:

* tomcat-openam.service
* openidm.service
* tomcat-openig.service
* tomcat-apps.service
* haproxy.service 


Use ```journalctl``` to view the system log. You can type "G" to skip to the end of the log.

## Running on Google Compute Engine (GCE)

The gce.yml playbook will create a base Centos image on GCE. The image will be ready to run the frstack.yml playbook against. 

## Environment specific configuration

Refer to the README.md file in each environment directory. Current environments:

* vagrant - single all in one install
* gce/ - Google compute Engine 
* 


## Speeding up re-installs using a proxy server 

[Note: This does not reliably work right now - see below]

Edit group_vars/all and uncomment the proxy server configuration.  Ansible will use 
the proxy when installing packages and when downloading zip files. 

Even if you are not behind a corporate firewall you may want to consider using a caching proxy
such as squid. You can install "squidman" for the mac.  

This build will download a lot of software (approx 1 GB)
and if you re-run it (to test configuration changes, for example) those bits will be
downloaded all over again.  A caching proxy will speed up the process 
by caching packages and zip files.  You may want to edit the squid configuration on 
the mac (~/Libraries/Preferences/squid.conf) and increase the size of maximum_object_size 
to 400GB (the OpenAM all-in distribution is approx. 350 GB)

[NOTE: See TODOs below. As it turn out, caching of yum packages is more tricky than just using 
a proxy server].


## Implementation Notes

* The guest is currently Fedora 22. The scripts assume the use of systemd - so this should work on
other distros that also support systemd. 
* For consistency between environments a forgerock user is created ("fr" - because no one likes to type 
long names). Most services run under this account. 
* To set up ssh for the fr user (so you can You can ```ssh fr@opename.example.com```)
 Add your public ssh key to roles/create-fr-user/files. Edit roles/create-fr-user/tasks/main.yml 
 to reflect the name of your pub key file.



### Ansible Notes

The install is split into two top level playbooks. The first playbook (vagrant.xml) primes the environment required 
for the main ForgeRock playbook (frstack.yml). Over time there will be an aws.yml playbook, a gce.yml, and so on.

The first playbook is responsible for installing a few base O/S packages and for create the "fr" forgerock user under
which the products will be installed. 

The second playbook "frstack.yml" does most of the heavy lifting and completes the install. 
The frstack.yml should be generic enough to run on any environment. This playbook is included from vagrant.yml .

There is a work-in-progress playbook called ```fr_optional.yml``` which is where optional software 
and configuration will go.



### TODO

If you are looking to dig in and contribute pull requests are welcome. Things that need to be done:

* Start migration of instances to Docker, and then eventually to Kubernetes. The image now has docker installed ready to go
* Using squid proxy does not work reliably with yum. Fedora dynamically picks a rpm server which messes up squid caching
* Make this work on both Debian / Centos / Ubuntu 15.x etc. (anything that supports systemd).
* policy agents install is not working / not completing. It installs the agent software but does not configure
* looks like the HOSTNAME needs to be set to the fqdn on the machine /etc/sysconfig/network  or openam config bombs out
  This is fixed for Vagrant by setting config.vm.hostname. Will need a fix for other environments
* tomcat agent installer does not put filter in global web.xml. Need to fix up apps web.xml
* Configure sample policies
* Add HA, multi-master replication, et
* Add some sample apps
* Configure openig as an agent
* Openig - gateway conf/ directory needs to be set to /opt/openig.
