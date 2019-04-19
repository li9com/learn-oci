# Lab08 - Creating images from containers.

## podman commit

- Check out the **podman-commit** man page:

```
man podman-commit
```

## Creating an Apache image

- Start a new centos:7 container as **root**, install httpd, iand modify startup page:

```
podman run -it centos:7 /bin/bash -c 'yum install -y httpd; yum clean all; echo "Custom Image" >/var/www/html/index.html'
```

- Make sure that the container is stopped:

```
# podman ps -a
CONTAINER ID  IMAGE                       COMMAND               CREATED        STATUS                    PORTS  NAMES
07bea49b4256  docker.io/library/centos:7  /bin/bash -c yum ...  2 minutes ago  Exited (0) 8 seconds ago         friendly_goldstine
```

- "Convert" the container to an image with `podman commit` command, where *d89efebc98e5* is the Container ID of the stopped centos:7 container:

```
# podman commit -c CMD="/usr/sbin/httpd -D FOREGROUND" 07bea49b4256 myhttpd
Getting image source signatures
Skipping fetch of repeat blob sha256:d69483a6face4499acb974449d1303591fcbb5cdce5420f36f8a6607bda11854
Copying blob sha256:8996bcacb91f6a5089ec53c2bb73ad6c4922ce881a9d45eb801b2df737295ad2
 53.69 MB / 53.69 MB [======================================================] 1s
Copying config sha256:2e4edb089d6e719500c57920db46ac27197dfced07f5159a4e8c2da159dccfe7
 1.24 KB / 1.24 KB [========================================================] 0s
Writing manifest to image destination
Storing signatures
2e4edb089d6e719500c57920db46ac27197dfced07f5159a4e8c2da159dccfe7
 
# podman images myhttpd
REPOSITORY          TAG      IMAGE ID       CREATED          SIZE
localhost/myhttpd   latest   2e4edb089d6e   13 seconds ago   266 MB
```

- Start a new container from the image we have just downloaded:

```
# podman run -d --name httpd -p 8080:80 myhttpd
```

- Make sure that the container works:

```
# curl $(podman inspect --format='{{ .NetworkSettings.IPAddress }}' httpd)
Custom Image
```

- Delete all containers:

```
# podman rm -af
```
