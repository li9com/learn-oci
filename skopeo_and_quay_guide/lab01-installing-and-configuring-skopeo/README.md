# Installing and configuring skopeo

- To install skopeo is just as easy as running the following command as root:

```
yum -y install skopeo
```

- Review the default configuration of local trust policy that doesn't perform any signature verification:

```
cat /etc/containers/policy.json
```

You can find more on the format of this file [here](https://www.mankier.com/5/policy.json).

- Review the default registry configuration. Notice that by default all signatures are stored in `/var/lib/atomic/sigstore`:

```
cat /etc/containers/registries.d/default.yaml
```

- Review all available commands and options supported by an arbitrary command:

```
skopeo -h
skopeo help run
```
