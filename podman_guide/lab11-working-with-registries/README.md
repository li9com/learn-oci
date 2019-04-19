# Lab11 - Working with registries
This lab explains how to create a private registry.

## Starting a registry from the official registry image

- Check the official registry documentation at `https://hub.docker.com/_/registry`

- Prepare persistent storage:

```
$ sudo mkdir -p /data/registry
$ sudo chcon -t container_file_t /data/registry
```

- Pull registry image as **root**:

```
# podman pull registry:2
```

- Inspect the image:

```
# podman inspect --format='{{ .ContainerConfig.Volumes }}' registry:2
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
  --name registry registry:2
```

- Make sure that the registry container works:

```
# podman ps
CONTAINER ID  IMAGE                         COMMAND               CREATED         STATUS             PORTS                   NAMES
9b70d2b70a9b  docker.io/library/registry:2  /entrypoint.sh /e...  14 seconds ago  Up 13 seconds ago  0.0.0.0:5000->5000/tcp  registry
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
REPOSITORY               TAG      IMAGE ID       CREATED             SIZE
localhost/custom_httpd   latest   f9553cc4f651   About an hour ago   266 MB
localhost:5000/apache    latest   f9553cc4f651   About an hour ago   266 MB
```

- Push the image to the registry at localhost:5000/apache:

```
# podman push --tls-verify=false localhost:5000/apache
Getting image source signatures
Copying blob sha256:d69483a6face4499acb974449d1303591fcbb5cdce5420f36f8a6607bda11854
 199.78 MB / 199.78 MB [===================================================] 17s
Copying blob sha256:c70e2be25cc7817fce82facb41143d45e4435529beac363f55f83d48097ccc7f
 53.69 MB / 53.69 MB [======================================================] 5s
Copying blob sha256:5f70bf18a086007016e948b04aed3b82103a36bea41755b6cddfaf10ace3c6ef
 1024 B / 1024 B [==========================================================] 0s
Copying config sha256:f9553cc4f651bb669263d422652d5f87a2951bb8cefb159b4b0b29aff4fb2474
 1.52 KB / 1.52 KB [========================================================] 0s
Writing manifest to image destination
Storing signatures
```

- Make sure that the image is stored on persistent storage:

```
# find /data/registry
/data/registry
/data/registry/docker
/data/registry/docker/registry
/data/registry/docker/registry/v2
...

```

- Configure your system to accept registires without TLS verification:

```
# vi /etc/containers/registries.conf
...
[registries.insecure]
registries = ['localhost:5000']
...
```

- Start an httpd container from localhost:5000/apache to verify that the image we've just pushed is accessible to us:

```
# podman run -d --name httpd localhost:5000/apache
432c46e2ed3e61f0981ee03797c914b72ec77759329d2c6567accea24e1e7d7b
```

- Make sure the Apache service works propery:

```
# curl http://$(podman inspect --format='{{ .NetworkSettings.IPAddress }}' httpd)
It works
```

- Delete all containers

```
# podman rm -af
432c46e2ed3e61f0981ee03797c914b72ec77759329d2c6567accea24e1e7d7b
9b70d2b70a9bb7bed4eae5b6fe1bf37e84db4f2df40cb61b22c798715cfe06d9
```
