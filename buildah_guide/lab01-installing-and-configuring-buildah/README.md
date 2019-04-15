# The puspose of this lab is to get you started with buildah and show you how to install it and navigate through configuration files

## Installing ang Configuring buildah

- buildah is installed with a single command ran as root:

```
yum -y install buildah
```

- Review the default configuration of local trust policy that doesn't perform any signature verification:

```
cat /etc/containers/policy.json
```

You can find more on the format of this file [here](https://www.mankier.com/5/policy.json).

- Review default registries that are consulted if registry part of an image is missing in a command:

```
cat /etc/containers/registries.conf
```

- Review default seccomp rules. Notice that the default action is **SCMP_ACT_ERRNO**, meaning all syscalls not explicitly permitted are blocked:

```
cat /usr/share/containers/seccomp.json
```

- Review default mount mappings. Notice that the only mapping by default is `/usr/share/rhel/secrets:/run/secrets`, which allows all containers to use the host's Red Hat subscriptions:

```
cat /usr/share/containers/mounts.conf
```
