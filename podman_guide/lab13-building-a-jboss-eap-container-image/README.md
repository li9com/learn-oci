# Lab13 - Building a JBoss EAP container image.

For this exercise you will need an account at [Red Hat Developer Portal](https://developers.redhat.com/).

- Download JBoss EAP 7.2 from https://developers.redhat.com/download-manager/file/jboss-eap-7.2.0.zip into the directory *podman_guide/lab13-building-a-jboss-eap-container-image*.

- Run `vagrant reload` from your host system to re-sync vagrant shared directories.

- Run the following commands to login to your VM as **root**:

```
$ vagrant ssh
$ sudo -i
#
```

- Copy the Dockerfile to the current directory.

```
# cp /vagrant/lab13-building-a-jboss-eap-container-image/Dockerfile .
```

- Copy JBoss EAP to the current directory:

```
# cp /vagrant/lab13-building-a-jboss-eap-container-image/jboss-eap-7.2.0.zip .
```

- Build an image from the Dockerfile:

```
# podman build -t eap --build-arg ADMIN_PASSWORD=secret .
```

- Run a container from the image:

```
# podman run -d --name eap -p 8080:8080 -p 9990:9990 eap
c793820576c01616f9da0619d3afb2f3a2cf1bb27b1d244a17996fc044124aae
```

- Make sure the image exists in the local cache:

```
# podman images eap
REPOSITORY      TAG      IMAGE ID       CREATED         SIZE
localhost/eap   latest   4bf75c131e3c   3 minutes ago   932 MB
```

# Use the following URL to login to JBoss EAP console with username *admin* and password *secret*:

```
http://172.24.0.11:9990/console/index.html
```
