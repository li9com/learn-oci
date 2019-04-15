# Lab10 - Creating new images with docker commit

## docker commit

- Check the "docker-commit" man page

```
man docker-commit
```

## Creating an Apache image

- Start a new centos:7 container, install httpd and modify startup page

```
docker run -it centos:7 /bin/bash -c 'yum install -y httpd; yum clean all; echo "Custom Image" >/var/www/html/index.html'
```

- Make sure that container is stopped

```
[vagrant@node1 ~]$ docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                     PORTS               NAMES
d89efebc98e5        centos:7            "/bin/bash -c 'yum..."   44 seconds ago      Exited (0) 7 seconds ago                       modest_ptolemy
```

- "Convert" container to a docker image with "docker commit" command, where *d89efebc98e5* is a Container ID of the stopped centos:7 container.

```
[vagrant@node1 ~]$ docker commit -c "CMD /usr/sbin/httpd -DFOREGROUND" d89efebc98e5 myhttpd
sha256:82656d2150f8676a87875858608ada30fd5a478f79f7a9fc9cd5a999edf24dd9

[vagrant@node1 learn-docker]$ docker images myhttpd
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
myhttpd             latest              82656d2150f8        6 seconds ago       255 MB
```

- Start a new container from the image we have just created

```
docker run -d --name httpd -p8080:80 myhttpd
```

- Make sure that image works

```
[vagrant@node1 ~]$ curl $(docker inspect --format='{{ .NetworkSettings.IPAddress }}' httpd)
Custom Image
```

- Delete all containers

```
docker rm -f $(docker ps -aq)
```
