## The purpose of this lab is to teach you how to build images from scratch, thus building on best practices of containerizing applications

# Build images from scratch

- First step is to create an **empty** container **from scratch**:

```
ctr=$(buildah from scratch)
```

- Notice that list of `buildah images` is empty, as no actual image is being used, but the container is indeed created:

```
buildah images
buildah containers
```

- To see if the container is truly empty, try to run bash inside it:

```
buildah run $ctr bash
```

As expected, the command failed with `executable file not found` error.

- As the new container lacks any package management tools, we will have to mount its rootfs locally and use host's package manager to install software:

```
mount=$(buildah mount $ctr)
yum -y --installroot $mount --releasever 7 --setopt=tsflags=nodocs --setopt=install_weak_deps=false --setopt=override_install_langs=en_US.utf8 install httpd >/dev/null 2>&1
```

As with `buildah from`, `buildah mount` command outputs the path to the mount point where the rootfs is mounted, which can be saved in a variable and referenced later.

- Now, let's delete yum cache in the mount point to reduce the size of the resulting image and unmount the rootfs:

```
rm -rf $mount/var/cache/yum
buildah umount $ctr
```

- Next steps are the same as with building images directly from any other base image. Copy the web content:

```
buildah copy $ctr ./index.html /var/www/html
```

- Expose HTTP port:

```
buildah config -p 80 $ctr
```

- Set the default command:

```
buildah config --cmd '/usr/sbin/httpd -D FOREGROUND' $ctr
```

- Commit the new image:

```
buildah commit $ctr centos7-httpd-scratch
```

- Notice that the resulting image is much smaller than the one built from `centos:7` image by ~140MB:

```
buildah images
```

- Next, run a container from that image:

```
podman run -d --name httpd-scratch centos7-httpd-scratch
```

- Now we need to obtain its IPAddress to make an HTTP request:

```
podman inspect -f {{.NetworkSettings.IPAddress}} httpd-scratch
curl <IPAddress>
```

The expected output is `BUILDAH GUIDE`.

- Lastly, we need to push our image to the remote registry so that other memebers of our team can benefit from it. Let's give it a meaningful tag first and then send it away:

```
buildah tag centos7-httpd-scratch centos7-httpd-scratch:2.4
buildah push --creds <HUB_USERNAME>:<HUB_PASSWORD> centos7-httpd-scratch:2.4 docker://docker.io/li9demo/centos7-httpd-scratch:2.4
```

At this point, you can go to your Docker Hub account and verify that the image has been uploaded.
