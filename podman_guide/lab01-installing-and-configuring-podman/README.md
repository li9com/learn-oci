# Lab1 - Installing and configuring podman
This document explains how to install podman on a CentOS 7 VM.

## Installation
- Install the **podman** package as follows:

```
sudo yum -y install podman
```

- Optional: install additional usefull packages as follows:

```
sudo yum -y install git
```

## Configuration

Review the default registries configuration file:

```
cat /etc/containers/registries.conf
```

As you can see, the default configuration for `[registries.search]` places **registry.access.redhat.com** first, so unless registry is specified in commands, podman looks for the image in Red Hat registry first.

- Review default configuration of local trust policy that doesn't perform any signature verification:

```
cat /etc/containers/policy.json
```

- Review default mount mappings. Notice that the only mapping by default is `/usr/share/rhel/secrets:/run/secrets`, which allows all containers to use the host's Red Hat subscriptions:

```
cat /usr/share/containers/mounts.conf
```

- Review default storage configuration:

```
cat /etc/containers/storage.conf
```
