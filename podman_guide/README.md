# Learn Podman
"Learn Podman" is is a step by step hands-on guide which teaches some practical Docker-related skills


## Labs
The repository consists of a number of subdirectories, which include all files required for the Labs.
Labs are structured as follows:

Lab    | Description
------ | -----------
Lab 0  | Creating Lab environment (please see below in this document)
Lab 1  | Installing and configuring podman
Lab 2  | Podman CLI
Lab 3  | Managing images
Lab 4  | Managing containers
Lab 5  | Using environment variables
Lab 6  | Using persistent storage
Lab 7  | Starting a multicontainer application
Lab 8  | Starting private registry
Lab 9  | Creating new images with podman commit
Lab 10 | Creating a simple Dockerfile
Lab 11 | Importing and exporting images
Lab 12 | Advanced Dockerfile
Lab 13 | Containerizing JBoss EAP


## Creating Lab environment
Most of the labs can be run on any Linux based VMs. However all labs are created and tested on CentOS 7 only.

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


### Starting lab environment
The lab environment can be provisioned using Vagrant as follows:

```
git clone https://github.com/li9com/learn-docker.git
cd learn-oci/podman_guide
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
Artemii Kropachev


