# Lab5 - Managing containers
This document will guide you on how to manage Docker containers via podman cli.

Included are:
- Starting new containers
- Stopping/starting existing containers
- Listing, running, and stopped containers
- Gathering container details
- Deleting containers
- Exposing container ports
- Executing an arbitrary command inside the container

## Starting new containers

- Check out the **podman-run** man page:

```
man podman-run
```

- Check out the built-in help:

```
podman run --help
```

or

```
podman h run
```

- Start an httpd container with no options:

```
$ podman run httpd
AH00557: httpd: apr_sockaddr_info_get() failed for ea6bd01f4226
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.0.1. Set the 'ServerName' directive globally to suppress this message
AH00557: httpd: apr_sockaddr_info_get() failed for ea6bd01f4226
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.0.1. Set the 'ServerName' directive globally to suppress this message
[Mon Apr 15 12:08:01.090412 2019] [mpm_event:notice] [pid 1:tid 140570179776576] AH00489: Apache/2.4.39 (Unix) configured -- resuming normal operations
[Mon Apr 15 12:08:01.091893 2019] [core:notice] [pid 1:tid 140570179776576] AH00094: Command line: 'httpd -D FOREGROUND'
^C[Mon Apr 15 12:08:07.492219 2019] [mpm_event:notice] [pid 1:tid 140570179776576] AH00491: caught SIGTERM, shutting down
```

Note! The container shows output to the screen.

Note! You need to stop container using "CTRL + C".

- Make sure that the container is not up and running:

```
$ podman ps -a
CONTAINER ID  IMAGE                           COMMAND           CREATED             STATUS                     PORTS  NAMES
ea6bd01f4226  docker.io/library/httpd:latest  httpd-foreground  About a minute ago  Exited (0) 46 seconds ago         dreamy_payne
```

Note! The `docker ps -a` shows status of all containers, including stopped ones.

- Start a new httpd container in background:

```
$ podman run -d httpd
97b1fc6febd11b71fea88c040f4b73e58692e9c6271849933c1049a187ca7d11
```

- Make sure that container is up and running. Notice that since we didn't provide a name via `--name` option, it defaults to a random one:

```
$ podman ps -a
CONTAINER ID  IMAGE                           COMMAND           CREATED         STATUS                    PORTS  NAMES
97b1fc6febd1  docker.io/library/httpd:latest  httpd-foreground  33 seconds ago  Up 32 seconds ago                **compassionate_thompson**
ea6bd01f4226  docker.io/library/httpd:latest  httpd-foreground  3 minutes ago   Exited (0) 2 minutes ago         dreamy_payne
```

- Start a temporary httpd container and terminate it via "CTRL + C":

```
$ podman run --rm httpd
AH00557: httpd: apr_sockaddr_info_get() failed for d9ab90daa79f
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.0.1. Set the 'ServerName' directive globally to suppress this message
AH00557: httpd: apr_sockaddr_info_get() failed for d9ab90daa79f
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.0.1. Set the 'ServerName' directive globally to suppress this message
[Mon Apr 15 12:13:26.302662 2019] [mpm_event:notice] [pid 1:tid 139920973512768] AH00489: Apache/2.4.39 (Unix) configured -- resuming normal operations
[Mon Apr 15 12:13:26.303838 2019] [core:notice] [pid 1:tid 139920973512768] AH00094: Command line: 'httpd -D FOREGROUND'
^C[Mon Apr 15 12:14:20.075201 2019] [mpm_event:notice] [pid 1:tid 139920973512768] AH00491: caught SIGTERM, shutting down
 
$ podman ps -a
CONTAINER ID  IMAGE                           COMMAND           CREATED        STATUS                    PORTS  NAMES
97b1fc6febd1  docker.io/library/httpd:latest  httpd-foreground  4 minutes ago  Up 4 minutes ago                 compassionate_thompson
ea6bd01f4226  docker.io/library/httpd:latest  httpd-foreground  7 minutes ago  Exited (0) 6 minutes ago         dreamy_payne
```

Notice that container has been deleted automatically, once stopped. That is the effect of `--rm` option.


## Stopping/starting existing containers

- Check the man pages for **podman-stop** and **podman-start**:

```
man podman-stop
man podman-start
```

- Check the running containers

```
$ podman ps
CONTAINER ID  IMAGE                           COMMAND           CREATED        STATUS            PORTS  NAMES
97b1fc6febd1  docker.io/library/httpd:latest  httpd-foreground  6 minutes ago  Up 6 minutes ago         compassionate_thompson
```

- Stop a running container

```
$ podman stop 97b1fc6febd1
97b1fc6febd11b71fea88c040f4b73e58692e9c6271849933c1049a187ca7d11
```

Note! It's up to you whether to use container ID or container name. We could stop the container as follows instead:

```
podman stop compassionate_thompson
```

- Make sure that container was stoped

```
$ podman ps -a
CONTAINER ID  IMAGE                           COMMAND           CREATED         STATUS                         PORTS  NAMES
97b1fc6febd1  docker.io/library/httpd:latest  httpd-foreground  9 minutes ago   Exited (0) About a minute ago         compassionate_thompson
ea6bd01f4226  docker.io/library/httpd:latest  httpd-foreground  11 minutes ago  Exited (0) 10 minutes ago             dreamy_payne
```

- Start the container again:

```
$ podman start compassionate_thompson
compassionate_thompson

$ podman ps
CONTAINER ID  IMAGE                           COMMAND           CREATED         STATUS            PORTS  NAMES
97b1fc6febd1  docker.io/library/httpd:latest  httpd-foreground  10 minutes ago  Up 7 seconds ago         compassionate_thompson
```

Note! We have used conainer name instead of container id.

- Start container with a custom name:

```
$ podman run -d --name my_custom_name httpd
6851862d5302947d98e638b5ab96a1bf07462e6cb8c8d4103043c0a5d979e711

$ podman ps
CONTAINER ID  IMAGE                           COMMAND           CREATED         STATUS             PORTS  NAMES
6851862d5302  docker.io/library/httpd:latest  httpd-foreground  4 seconds ago   Up 3 seconds ago          my_custom_name
97b1fc6febd1  docker.io/library/httpd:latest  httpd-foreground  12 minutes ago  Up 59 seconds ago         compassionate_thompson
```

- Start a new container with another name. Make sure that name is properly shown

```
$ podman run -d --name it_works_container httpd
5323d400eafe15d6ba65219623fb545d008c9332e931e7397f71755db7f36e63

$ podman ps
CONTAINER ID  IMAGE                           COMMAND           CREATED             STATUS                 PORTS  NAMES
5323d400eafe  docker.io/library/httpd:latest  httpd-foreground  3 seconds ago       Up 2 seconds ago              it_works_container
6851862d5302  docker.io/library/httpd:latest  httpd-foreground  About a minute ago  Up About a minute ago         my_custom_name
97b1fc6febd1  docker.io/library/httpd:latest  httpd-foreground  13 minutes ago      Up 2 minutes ago              compassionate_thompson
```


## Listing running and stopped containers

Note! We already used `podman ps` to list running and stopped containers. In this chapter we will learn how to use advanced `podman ps` functionallity.

- Check the **podman-ps** man page:

```
man podman-ps
```

- Display running and stopped containers, respectivelly:

```
$ podman ps
CONTAINER ID  IMAGE                           COMMAND           CREATED         STATUS            PORTS  NAMES
5323d400eafe  docker.io/library/httpd:latest  httpd-foreground  2 minutes ago   Up 2 minutes ago         it_works_container
6851862d5302  docker.io/library/httpd:latest  httpd-foreground  3 minutes ago   Up 3 minutes ago         my_custom_name
97b1fc6febd1  docker.io/library/httpd:latest  httpd-foreground  15 minutes ago  Up 4 minutes ago         compassionate_thompson

$ podman ps -a
CONTAINER ID  IMAGE                           COMMAND           CREATED         STATUS                     PORTS  NAMES
5323d400eafe  docker.io/library/httpd:latest  httpd-foreground  2 minutes ago   Up 2 minutes ago                  it_works_container
6851862d5302  docker.io/library/httpd:latest  httpd-foreground  3 minutes ago   Up 3 minutes ago                  my_custom_name
97b1fc6febd1  docker.io/library/httpd:latest  httpd-foreground  15 minutes ago  Up 4 minutes ago                  compassionate_thompson
ea6bd01f4226  docker.io/library/httpd:latest  httpd-foreground  18 minutes ago  Exited (0) 17 minutes ago         dreamy_payne
```

- Display container IDs only:

```
$ podman ps -aq
5323d400eafe
6851862d5302
97b1fc6febd1
ea6bd01f4226
```

Note! We will be using this command a lot in the next labs.

- Apply an output filter using -f option:

```
$ podman ps -af status=exited
CONTAINER ID  IMAGE                           COMMAND           CREATED         STATUS                     PORTS  NAMES
ea6bd01f4226  docker.io/library/httpd:latest  httpd-foreground  24 minutes ago  Exited (0) 23 minutes ago         dreamy_payne
```

- Apply output format using *--format* option:

```
$ podman ps --format "{{.ID}} {{.Image}}"
5323d400eafe docker.io/library/httpd:latest
6851862d5302 docker.io/library/httpd:latest
97b1fc6febd1 docker.io/library/httpd:latest
```

## Gathering container details

- Check out the **podman-inspect** man page:

```
man podman-inspect
```

- Start a new container named *myhttpd* as **root**:

```
# podman run -d --name myhttpd httpd
3930cf37b13fe1e2f9c3b1e1c3c561a1f7ddd5317393bb1e71e8f6c03c8892b7
```

- Inspect container details using `podman inspect`:

```
# podman inspect myhttpd | python -m json.tool
```

- Customize `docker inspect` output to show the container's IPAddress only:

```
# podman inspect --format '{{.NetworkSettings.IPAddress}}' myhttpd
10.88.0.3
```

- Try to reach httpd running in the container on this IP address:

```
# curl $(podman inspect --format '{{.NetworkSettings.IPAddress}}' myhttpd)
<html><body><h1>It works!</h1></body></html>
```

This is useful in scripts.

Note! We started a httpd container which is Apache web server. It is expected that the application answer is "It works".


## Deleting containers

- Check out the **podman-rm** man page:

```
man podman-rm
```

Note! By default, the `podman rm` command deletes only stopped containers. If you need to delete a running container, option *-f* (or *--force*) is required.

- Try to delete a stopped container:

```
$ podman ps -a
CONTAINER ID  IMAGE                           COMMAND           CREATED         STATUS                     PORTS  NAMES
5323d400eafe  docker.io/library/httpd:latest  httpd-foreground  22 minutes ago  Up 22 minutes ago                 it_works_container
6851862d5302  docker.io/library/httpd:latest  httpd-foreground  24 minutes ago  Up 23 minutes ago                 my_custom_name
97b1fc6febd1  docker.io/library/httpd:latest  httpd-foreground  36 minutes ago  Up 24 minutes ago                 compassionate_thompson
ea6bd01f4226  docker.io/library/httpd:latest  httpd-foreground  38 minutes ago  Exited (0) 37 minutes ago         dreamy_payne

$ podman rm ea6bd01f4226
ea6bd01f4226038c837bc01bcd57ad6e51bd30c14da21ab4a7f74dc34b08ee6b
 
$ podman ps -a
CONTAINER ID  IMAGE                           COMMAND           CREATED         STATUS             PORTS  NAMES
5323d400eafe  docker.io/library/httpd:latest  httpd-foreground  22 minutes ago  Up 22 minutes ago         it_works_container
6851862d5302  docker.io/library/httpd:latest  httpd-foreground  24 minutes ago  Up 24 minutes ago         my_custom_name
97b1fc6febd1  docker.io/library/httpd:latest  httpd-foreground  36 minutes ago  Up 25 minutes ago         compassionate_thompson
```

- Try to delete a running container:

```
$ sudo -i
# podman ps
CONTAINER ID  IMAGE                           COMMAND           CREATED        STATUS            PORTS  NAMES
15c80b897d23  docker.io/library/httpd:latest  httpd-foreground  6 minutes ago  Up 6 minutes ago         myhttpd

# podman rm myhttpd
cannot remove container 15c80b897d232c95e127ed79a627e11b019b74bb5e2f0a3166d7e9387b59ee7f as it is running - running or paused containers cannot be removed: container state improper
```

- Try again with *-f*:

```
# podman rm -f myhttpd
15c80b897d232c95e127ed79a627e11b019b74bb5e2f0a3166d7e9387b59ee7f

# podman ps -a
CONTAINER ID  IMAGE  COMMAND  CREATED  STATUS  PORTS  NAMES

# logout
```

Note! Container has been succesfully deleted.

- Delete all containers:

```
$ podman rm -af
5323d400eafe15d6ba65219623fb545d008c9332e931e7397f71755db7f36e63
6851862d5302947d98e638b5ab96a1bf07462e6cb8c8d4103043c0a5d979e711
97b1fc6febd11b71fea88c040f4b73e58692e9c6271849933c1049a187ca7d11

$ podman ps -a
CONTAINER ID  IMAGE  COMMAND  CREATED  STATUS  PORTS  NAMES
```

Note! We will use this command often to clean up the system.


## Exposing container ports

By default, containers use an internal network which is not accessible from outside of the Docker node.  Container port may be bound to a Docker node port using *-p* option of the `podman run`.

- Check out the **podman-run** man page. Look for *-p*, or *--publish* option:

```
man podman-run
```

- Check out the built-in documentation:

```
$ podman h run | grep publish
   --publish value, -p value                     Publish a container's port, or a range of ports, to the host (default [])
   --publish-all, -P                             Publish all exposed ports to random ports on the host interface
```

- Start a new httpd container and bind it to port *8080* of the Docker node as **root**:

```
# podman run -d --name httpd -p 8080:80 httpd
f97392e51038cf0ec3e589eb5f2d590318e7fb9bf398d5783d1196cd69145b82
```

- Make sure that **podman ps** output shows the port binding:

```
# podman ps
CONTAINER ID  IMAGE                           COMMAND           CREATED        STATUS            PORTS                 NAMES
f97392e51038  docker.io/library/httpd:latest  httpd-foreground  6 seconds ago  Up 6 seconds ago  0.0.0.0:8080->80/tcp  httpd
```

- Access containerized application using Node IP address:

```
# curl 127.0.0.1:8080
<html><body><h1>It works!</h1></body></html>

# curl 172.24.0.11:8080
<html><body><h1>It works!</h1></body></html>
```

Note! Application is accessible from the Docker Node via both loopback and external IPs.

- Try to start a new httpd container and bind it to the same Docker node port.

```
# podman run -d --name new_httpd -p 8080:80 httpd
cannot listen on the TCP port: listen tcp4 :8080: bind: address already in use
```

Note! The error is expected as we've already bound that port to another container.

- Check out running containers. Make sure that only one container is bound to port *8080* of the Docker node:

```
# podman ps -a
CONTAINER ID  IMAGE                           COMMAND           CREATED             STATUS            PORTS                 NAMES
c2064d583325  docker.io/library/httpd:latest  httpd-foreground  About a minute ago  Created           0.0.0.0:8080->80/tcp  new_httpd
f97392e51038  docker.io/library/httpd:latest  httpd-foreground  4 minutes ago       Up 4 minutes ago  0.0.0.0:8080->80/tcp  httpd
```

- Delete all containers

```
# podman rm -af
c2064d5833255c3086561db288cea9aad258053d2a7d537b9438a6015af62dc7
f97392e51038cf0ec3e589eb5f2d590318e7fb9bf398d5783d1196cd69145b82
```

- Start a new Jenkins container and bind it to port 8080 of the Docker node:

```
# podman run -d --name jenkins -p 8080:8080 jenkins
...
# podman ps
CONTAINER ID  IMAGE                             COMMAND               CREATED         STATUS             PORTS                   NAMES
66cccb48da3e  docker.io/library/jenkins:latest  /bin/tini -- /usr...  32 seconds ago  Up 32 seconds ago  0.0.0.0:8080->8080/tcp  jenkins

```

Note! Make sure that `podman run` automatically downloaded the jenkins image.

Note! Jenkins container listens on port 8080.

- Try to access Jenkins appliation from your workstation by opening the following URL in your browser:

```
http://node1.172.24.0.11.nip.io:8080
```

or

```
http://172.24.0.11:8080
```

Note! You need to access the service from your Vagrant host and **not** from inside the VM.

Note! You should see the default Jenkins configration page named "Getting Started".

- Once you are done, delete all containers:

```
podman rm -af
```

## Executing custom commands inside a conainer

You may override the default command (application process) started, once a container is run. This is achieved by passing a *COMMAND* argument, as shown below:

```
podman run <IMAGE> <COMMAND>
```

You may also connect to a running container's shell using `podman exec`:

```
podman exec -it <IMAGE> <COMMAND>
```

More information is available in the man page

```
man podman-exec
```

- Start a httpd container with */bin/sh*:

```
$ podman run -it httpd /bin/sh
# pwd
/usr/local/apache2
# ls -l
total 32
drwxr-sr-x. 2 root www-data  276 Apr  2 23:38 bin
drwxr-sr-x. 2 root www-data  167 Apr  2 23:38 build
drwxr-sr-x. 2 root www-data   78 Apr  2 23:38 cgi-bin
drwxr-sr-x. 4 root www-data   84 Apr  2 23:38 conf
drwxr-sr-x. 3 root www-data 4096 Apr  2 23:38 error
drwxr-sr-x. 2 root www-data   24 Apr  2 23:38 htdocs
drwxr-sr-x. 3 root www-data 8192 Apr  2 23:38 icons
drwxr-sr-x. 2 root www-data 4096 Apr  2 23:38 include
drwxr-sr-x. 2 root www-data    6 Apr  2 23:38 logs
drwxr-sr-x. 2 root www-data 8192 Apr  2 23:38 modules
# whoami
root

$ podman ps -a
CONTAINER ID  IMAGE                           COMMAND  CREATED             STATUS                     PORTS  NAMES
45fa90eeb0c2  docker.io/library/httpd:latest  /bin/sh  About a minute ago  Exited (0) 33 seconds ago         trusting_ardinghelli
```

Notice that the container stopped once we exited the shell.

- Start a new httpd container as **root**:

```
# podman run -d --name httpd httpd
390cc08d822ead97d6fc1a97a0ebab9236b42ed16e628b0a5cc4808de9a9eb9c
 
# podman ps
CONTAINER ID  IMAGE                           COMMAND           CREATED        STATUS            PORTS  NAMES
390cc08d822e  docker.io/library/httpd:latest  httpd-foreground  8 seconds ago  Up 7 seconds ago         httpd
```

Note! The container starts normally in detached (*-d*) mode.

- Check environment variables inside the container using `env` subcommand:

```
# podman exec httpd env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
TERM=xterm
HOSTNAME=eea3088f9ccc
container=podman
HTTPD_PREFIX=/usr/local/apache2
HTTPD_VERSION=2.4.39
HTTPD_SHA256=b4ca9d05773aa59b54d66cd8f4744b945289f084d3be17d7981d1783a5decfa2
HTTPD_PATCHES=
APACHE_DIST_URLS=https://www.apache.org/dyn/closer.cgi?action=download&filename= 	https://www-us.apache.org/dist/ 	https://www.apache.org/dist/ 	https://archive.apache.org/dist/
```

- Connect to the httpd container console and modify its *index.html* file:

```
# podman exec -it httpd bash
root@eea3088f9ccc:/usr/local/apache2# 
root@eea3088f9ccc:/usr/local/apache2# ls
bin  build  cgi-bin  conf  error  htdocs  icons  include  logs	modules
root@eea3088f9ccc:/usr/local/apache2# 
root@eea3088f9ccc:/usr/local/apache2# whoami
root
root@eea3088f9ccc:/usr/local/apache2# 
root@eea3088f9ccc:/usr/local/apache2# cat htdocs/index.html 
<html><body><h1>It works!</h1></body></html>
root@eea3088f9ccc:/usr/local/apache2# 
root@eea3088f9ccc:/usr/local/apache2# echo "It has been changed" > htdocs/index.html         
root@eea3088f9ccc:/usr/local/apache2# 
root@eea3088f9ccc:/usr/local/apache2# cat htdocs/index.html 
It has been changed
root@eea3088f9ccc:/usr/local/apache2# exit
```

- Verify that the web page has indeed been changed:

```
# curl $(podman inspect --format '{{.NetworkSettings.IPAddress}}' httpd)
It has been changed
```

- Remove all containers:

```
# podman rm -af
eea3088f9cccc00fcd7dcfb13655fd99759a319c8b34769135030628c138b6e2

# logout
```

