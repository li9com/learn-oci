# The purpose of this lab is to teach you fundamental skills required to build OCI-compliant container images directly using buildah commands. This approach provides more flexibility than Dockerfiles, as image builds can be easily scripted.

## Building images directly

- First, we need to create a container to start with. For the purposes of this exercise, it will be based on `centos:7` image:

```
ctr=$(buildah from centos:7)
```

As the main idea behind buildah is scripting, several commands output names of the resources they create, which can be saved in a variable and referenced in the commands that come furter.

- Next step is to configure labels:

```
buildah config --label created-by='Aleksey Usov' --label lab=buildah-guide/lab04-building-images-directly/README.md $ctr
```

- To form the next layer, we will install Apache web server in the image:

```
buildah run $ctr -- bash -c 'yum -y update >/dev/null 2>&1 && yum -y --setopt tsflags=nodocs install httpd >/dev/null 2>&1 && yum clean all'
```

- Thirdly, we need to provide an actual web content:

```
buildah copy $ctr ./index.html /var/www/html
```

Notice that unlike for `buldah run` command or `RUN` Dockerfile instruction, we don't have to specify the target name of the file, just the destination directory.

- Next, expose HTTP port:

```
buildah config -p 80 $ctr
```

- Another configuration we need is the command to run when a container is created from the image:

```
buildah config --cmd '/usr/sbin/httpd -D FOREGROUND' $ctr
```

- Finally, let's commit our image:

```
buildah commit $ctr centos7-httpd
```

- Now that everything is ready, run a new container from the image:

```
podman run -d --name httpd centos7-httpd
```

- Inspect the running container to obtain its IPAddress and request the web server's content:

```
podman inspect -f {{.NetworkSettings.IPAddress}} httpd
curl <IPAddress>
```

The expected output is `BUILDAH GUIDE`.

- Let's do a quick clean up of our environment:

```
podman stop -a
podman rm -a
buildah rm -a
buildah rmi -a
```
