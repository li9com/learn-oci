# The purpose of this lab is to teach you fundamental skills required to build OCI-compliant container images using Dockerfiles. Being a standard mechanism of creating new images for years, it will play the role of a bridge between familiar concepts of docker/podman and new features provided by buildah. As this lab focuses on buildah, it comes with podman pre-installed.

## Building images using Dockerfiles

- Prepare `Dockerfile` with the following contents:

```
FROM centos:7

LABEL created-by "Aleksey Usov" \
      lab-directory buildah-guide/lab03-building-images-using-dockerfiles/README.md

RUN yum -y update >/dev/null 2>&1 && \
    yum -y --setopt tsflags=nodocs install httpd >/dev/null 2>&1 && \
    yum clean all

COPY ./index.html /var/www/html

EXPOSE 80

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
```

- You will also need an `index.html` file to provide a sample content for the web server:

```
BUILDAH GUIDE
```

- Now that you're all set, run the following command to build your first image layer by layer and tag it `centos7-httpd:latest`:

```
buildah bud -f Dockerfile -t centos7-httpd .
```

Notice dot (.) at the end of the command - this is the context directory.
Also, we could omit `-f Dockerfile`, as we're using default name for  the file with build instructions.

- Let's see if our image is present in the local store:

```
buildah images
podman images
```

As you can see, both buildah and podman are able to see each other's images, as they are fully OCI-compliant.

- Now let's run a container from that image:

```
podman run -d --name httpd centos7-httpd
```

- Now observe the difference in container view from buildah and podman perspectives:

```
podman ps
buildah containers
```

As you may notice, the output is different. The reason is buildah and podman use different internal representations for containers which makes them incompatible.

- As a next step, we have to obtain the container's IP address and request our index page:

```
podman inspect -f {{.NetworkSettings.IPAddress}} httpd
curl <IPAddress>
```

The expected output is `BUILDAH GUIDE`.

- Next, take a look at the metadata of the image to see how they correspond to instructions in the Dockerfile. Again, we use podman due to incompatibility between buildah and podman container formats:

```
podman inspect httpd
```

For example, `.OCIv1.ExposedPorts` structure contains ports as they are in the `EXPOSE` istruction.

- Now let's modify web content of the server by starting a child container from our image, updating the index file in the image and committing the changes:

```
ctr=$(buildah from centos7-httpd)
buildah run $ctr bash -c 'echo "Modified Content" > /var/www/html/index.html'
buildah commit $ctr centos7-httpd-modified
```

- Now that the image is ready, let's run it using podman:

```
podman run -d --name httpd-modified centos7-httpd-modified
```

- Again, we need to obtain the container's IPAddress in order to fetch our content from the server:

```
podman inspect -f {{.NetworkSettings.IPAddress}} httpd-modified
curl <IPAddress>
```

The expected output is `Modified Content`.

- Finally, let's clean everything up:

```
podman stop $(podman ps -aq) **or** podman stop -a
podman rm -a
buildah rm -a
buildah rmi -a
```
