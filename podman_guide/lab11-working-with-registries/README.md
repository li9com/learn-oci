# Lab11 - Working with registries
This lab explains how to create a private registry.

## Starting a registry from the official registry image

- Check the official registry documentation at `https://hub.docker.com/_/registry`

- Prepare persistent storage:

```
$ sudo mkdir -p /data/registry
$ sudo chcon -t container_file_t /data/registry
```

- Pull registry image:

```
# podman pull registry:2
```

- Inspect the image:

```
# podman inspect --format='{{ .Config.Volumes }}' registry:2
map[/var/lib/registry:{}]
```

Note! We need to mount persistent data at **/var/lib/registry**.

- Start registry container with the following configuration:

Parameter      | Value
-------------- | -----
Exposed port   | 5000
Name           | registry
Volume         | */var/lib/registry* is bound to */data/registry* on the node
Restart policy | always

```
# podman run -d -p 5000:5000 \
  -v /data/registry:/var/lib/registry \
  --restart always \
  --name registry registry:2
```

- Make sure that the registry container works:

```
# podman ps

```

- Try to access registry service using curl. Make sure that it returns '{}':

```
# curl http://localhost:5000/v2/
{}
```

## Pushing images to registry
- Tag existing httpd images as localhost:5000/apache

```
# podman tag httpd localhost:5000/apache
```

- Make sure that the image has been properly tagged

```
# podman images localhost:5000/apache

```

- Push the image to the registry at localhost:5000/apache:

```
# podman push localhost:5000/apache

```

- Make sure that the image is stored on persistent storage:

```
# find /data/registry

```
podman rmi apache docker.io/httpd localhost:5000/apache docker.io/centos/httpd-24-centos7
```

- Start an httpd container from localhost:5000/apache to verify that the image we've just pushed is accessible to us:

```
# podman run -d --name httpd localhost:5000/apache

```

- Make sure the Apache service works propery:

```
# curl http://$(podman inspect --format='{{ .NetworkSettings.IPAddress }}' httpd)
<html><body><h1>It works!</h1></body></html>
```

- Delete all containers

```
podman rm -af
```
