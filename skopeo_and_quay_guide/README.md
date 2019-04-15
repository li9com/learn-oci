# Skopeo and Quay Guide
"Skopeo and Quay Guide" is a step by step hands-on guide which teaches some practical skopeo-related skills


## Labs
The repository consists of a number of subdirectories, which include all files required for the Labs.
Labs are structured as follows:

Lab    | Description
------ | -----------
Lab 0  | Creating Lab environment (please see below in this document)
Lab 1  | Installing and configuring skopeo
Lab 2  | Copying images
Lab 3  | Inspecting images
Lab 4  | Signing images
Lab 5  | Quay registry


## Creating Lab environment
Most of the labs can be run on any Linux-based VMs. However, all labs were tested on CentOS 7 only.


### Virtual Machine
The repository includes a Vagrantfile which deploys a VM with the following configuration:

Option   | Value
-------- | -----
RAM      | 4096M
vCPU     | 2
IP       | 172.24.0.11
Hostname | node1.172.24.0.11.nip.io
Box      | centos/7


### Additional configuration

The VM is customized as follows:
- SELinux is disabled in order to use subdirectory `/home/vagrant/sigstore` as a webroot of signature server.
- Apache web server is installed.
- `/var/www/html` is re-created as a symlink to `/home/vagrant/sigstore/li9demo`
- Default Apache welcome page configuration is deleted
- Apache web server is started


### Host machine requrements

The host machine can be configured on the following OS:
- MacOS
- Windows
- Fedora Linux
- CentOS 7

The following software is required:
- VirtualBox (Windows and MacOS)
- libvirt (Linux only)
- Vagrant
- git
- vi or vim


### Environment
For the purposes of this subject, it's necessary to create accounts at [Docker Hub](https://hub.docker.com/) and [Quay Registry](https://quay.io). This is completely free and they will be used for copying and signing images in Lab 4.


### Starting lab environment
The lab environment can be provisioned using Vagrant as follows:

```
git clone https://github.com/li9com/learn-oci.git
cd learn-oci/skopeo
vagrant up
```

### Connecting to the Lab VM

Once the VM is provisioned, you may connect to it using SSH as follows:

```
vagrant ssh
```

Note! You will be connected as the "vagrant" user which is allowed to use sudo to run commands under the root account:

```
sudo yum install -y epel-release
```


## Authors
Aleksey Usov
