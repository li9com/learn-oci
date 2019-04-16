# Lab09 - Building images using Dockerfile

## Building Apache image from Dockerfile

- Check out the *lab11-simple-Dockerfile/Dockerfile* file

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

- Check image properties

```
# podman inspect custom_httpd | python -m json.tool
```

## Image verification

- Start a new httpd container from the **custom_httpd** image

```
# podman run -d --name httpd -p 8080:80 custom_httpd


# podman ps

```

- Access the service

```
# curl http://$(podman inspect --format='{{ .NetworkSettings.IPAddress }}' httpd)
It works
```

- Remove all containers

```
podman rm -af
```

