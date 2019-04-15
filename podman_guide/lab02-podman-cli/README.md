## The goal of this guide is to help you get all the information you may need without having to consult the web

# Getting help

- Podman package contains the docs you may find on Github:

```
rpm -qd podman | grep doc
...
/usr/share/doc/podman-0.12.1.2/README-hooks.md
/usr/share/doc/podman-0.12.1.2/README.md
...
```

- In order to get help on all available commands, just type `podman`. Each individual command has its own build-in documentation, available via `podman h <COMMAND>` or `podman help <COMMAND>`. Below are a couple of examples:

```
podman h pod
podman h export
```

- If you ever need to go deeper, podman global options and each command are documented in man pages as well:

```
man podman
man podman-pod
man podman-export
```

In fact, all you have to remember is `man podman` and names of other man pages are provided there.

- Getting help online

Online documentation and tutorials are available on the podman page on [Github](https://github.com/containers/libpod).
