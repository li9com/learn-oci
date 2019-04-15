# Buildah Guide
"Buildah Guide" is a step by step hands-on guide which teaches some practical buildah-related skills


## Labs
The repository consists of a number of subdirectories, which include all files required for the Labs.
Labs are structured as follows:

Lab    | Description
------ | -----------
Lab 0  | Creating Lab environment (please see below in this document)
Lab 1  | Installing and configuring buildah
Lab 2  | Available commands
Lab 3  | Building images using Dockerfiles
Lab 4  | Building images directly
Lab 5  | Building images from scratch


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
- shadow-utils46-newxidmap package is installed from a 3rd party repository to enable user namespaces for rootless containers
- Maximum number of user namespaces is set to 10000 persistently
- Numerical subordinate user ID an count are configured
- Numerical subordinate group ID an count are configured
- slirp4netns package is installed from a 3rd party repository to enable network namespaces for rootless containers


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
For the purposes of this guide, it's necessary to create accounts at [Docker Hub](https://hub.docker.com/). This is completely free and they will be used for copying an image in Lab 5.


### Starting lab environment
The lab environment can be provisioned using Vagrant as follows:

```
git clone https://github.com/li9com/learn-oci.git
cd learn-oci/buildah_guide
vagrant up
```

### Connecting to the Lab VM

Once the VM is provisioned, you may connect to it using SSH as follows:

```
vagrant ssh
```

Note! You will be connected as the "vagrant" user which is allowed to use sudo to run commands under the root account:

```
sudo yum -y install buildah
```

For the purposes of this guide, it's recommended to login as root:

```
sudo -i
```

## Authors
Aleksey Usov
