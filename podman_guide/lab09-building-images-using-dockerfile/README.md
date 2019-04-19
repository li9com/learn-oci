# Lab09 - Building images using Dockerfile

## Building Apache image from Dockerfile

- Check out the *lab11-working-with-registries/Dockerfile* file.

- Build an Apache image using the following command as **root**:

```
# podman build -t custom_httpd .
```

Note! Your output may be different.

- Make sure that newly built image exists:

```
# podman images custom_httpd
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
custom_httpd        latest              8710b43c848d        9 minutes ago       255 MB
```

- Check image properties:

```
# podman inspect custom_httpd | python -m json.tool
```

## Image verification

- Start a new httpd container from the **custom_httpd** image:

```
# podman run -d --name httpd -p 8080:80 custom_httpd
37ebb2c27478dd14a9b09c253bde9d40a7062345f28b0b7de46a4cdbe163474b

# podman ps
CONTAINER ID  IMAGE                          COMMAND               CREATED         STATUS             PORTS                 NAMES
37ebb2c27478  localhost/custom_httpd:latest  /bin/sh -c /usr/s...  23 seconds ago  Up 23 seconds ago  0.0.0.0:8080->80/tcp  httpd
```

- Access the service:

```
# curl http://$(podman inspect --format='{{ .NetworkSettings.IPAddress }}' httpd)
It works
```

- Remove all containers:

```
# podman rm -af
37ebb2c27478dd14a9b09c253bde9d40a7062345f28b0b7de46a4cdbe163474b
aef4f95d4c8bfe63c1580d36355ad813e60f14e106a137e902c77d21f071c4ad
```
