# Lab10 - Exporting and importing container images

This lab covers the following:
- Exporting and importing container layers
- Saving and loading docker images
- Creating an echo container image
- Creating a base OS container image

## Exporting and importing container layers

- Check the **podman--import** and **podman-export** man pages

```
man podman-import
man podman-export
```

Note! We will be using these commands to import and export container layers.

- Start and modify a container from httpd image:

```
# podman run --name newhttpd -it httpd bash -c 'echo "New output" > /usr/local/apache2/htdocs/index.html'
```

- Export container layers:

```
# podman export newhttpd > /tmp/newhttpd.tar
```

- Import /tmp/newhttpd.tar as a new image:

```
# podman import /tmp/newhttpd.tar newimage
```

- Make sure that the image exists:

```
# podman images newimage

```

Note! This image is useless for now. We will learn how to improve it a bit later.

## Echo container image

- Determine which libraries are required for **echo** binary to work:

```
# ldd /bin/echo
	linux-vdso.so.1 =>  (0x00007fff1dfd0000)
	libc.so.6 => /lib64/libc.so.6 (0x00007f6533e12000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f65341df000)
```

- Create a directory structure and copy all files into sorresponding subdirectories:

```
# mkdir -p /tmp/echo_image/{bin,lib64}
# cp /bin/echo /tmp/echo_image/bin
# cp /lib64/libc.so.6 /tmp/echo_image/lib64
# cp /lib64/ld-linux-x86-64.so.2 /tmp/echo_image/lib64
```

- Create a tar archive from that directory:

```
# tar -C /tmp/echo_image -cf /tmp/echo_image.tar .
```

- Import the tar as a new container:

```
# podman import /tmp/echo_image.tar echo_image

```

- Make sure that the new image exists:

```
# podman images echo_image

```

- Make sure that the image works:

```
# podman run echo_image /bin/echo "It works well"

```

## Loading and saving images

- Check out **podman-save** and **podman-load** man pages:

```
man podman-save
man podman-load
```

- Save httpd image into a tar archive:

```
# podman save httpd >/tmp/httpd.tar
```

- Check the image layout inside the archive:

```
# tar -tvf /tmp/httpd.tar

```

- Delete httpd container image:

```
# podman rmi httpd
```

- Load the image from **/tmp/httpd.tar**:

```
# podman load -i /tmp/httpd.tar
```
Note! There is no need to specify image name as it is saved in the image metadata.

- Make sure that the image exists with all metadata:

```
# podman images httpd

```

## Base OS images

The following commands can be used to create a base os directory layout:

```
# mkdir /tmp/base
# yum install -y yum-utils yumdownloader centos-release
# rpm --root /tmp/base --nodeps -ivh centos-release*.rpm
# yum --installroot=/tmp/base -y --setopt=tsflags=nodocs install yum
# rm -rf /tmp/base/var/cache/yum
```

- Create a tar archive from the directory:

```
# tar -C /tmp/base -cf /tmp/centos7_base.tar .
```

- Import the tar as a base os image:

```
# podman import /tmp/centos7_base.tar centos7_base

```

- Make sure that the image exists:

```
# podman images centos7_base

```

- Run a container from newly created image:

```
# podman run -ti centos7_base /bin/bash
bash-4.2# exit
exit
# 
```

- Remove all containers

```
podman rm -af
```
