# Lab4 - Managing container images
This document will guide you on how to manage container images using podman

## Searching images

### Docker Hub

Note! This part of the lab is peformed on your workstation and not inside the VM.

- Open your browser (like FireFox or Google Chrome)
- Open the link https://hub.docker.com
- Type "mariadb" in the search field
- Press ENTER

You should be able to see a list of images that have **mariadb** in their names.

- Click on the "> DETAILS" link on the right
- Scroll down trough the documenation

### Podman CLI

- Check out the **podman-search** man page:

```
$ man podman-search
```

- Try finding an Apache web server image:

```
$ podman search httpd
```

- Show 5 most popular mariadb images:

```
$ podman search --limit 5 mariadb
```

- Look for official tomcat images:

```
$ podman search -f is-official=true tomcat
INDEX       NAME                       DESCRIPTION                                       STARS   OFFICIAL   AUTOMATED
docker.io   docker.io/library/tomcat   Apache Tomcat is an open source implementati...   2347    [OK]       
docker.io   docker.io/library/tomee    Apache TomEE is an all-Apache Java EE certif...   65      [OK]
```

Notice that podman always looks for images in **registry.lab.example.com** registry, as per **/etc/containers/registries.conf** unless you prepend the image name with registry and repository address.


## Downloading images
- Check out the **podman-pull** man page:

```
$ man podman-pull
```

- Download an Apache image

```
$ podman pull httpd
```

- Make sure that image has been downloaded successfully

```
$ podman images
REPOSITORY                TAG      IMAGE ID       CREATED       SIZE
docker.io/library/httpd   latest   d4a07e6ce470   12 days ago   137 MB
```

- Download Apache image with tag 2.2

```
$ podman pull httpd:2.2
```

- Make sure that both images do exist locally:

```
$ podman images
REPOSITORY                TAG      IMAGE ID       CREATED         SIZE
docker.io/library/httpd   latest   d4a07e6ce470   12 days ago     137 MB
docker.io/library/httpd   2.2      e06c3dbbfe23   15 months ago   180 MB
```

## Displaying downloaded images

- Check the **podman-images** man page

```
$ man podman-images
```

- Display only image IDs

```
$ podman images -aq
d4a07e6ce470
e06c3dbbfe23
```

- Get a formatted output

```
$ podman images --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}"
IMAGE ID       REPOSITORY                TAG
d4a07e6ce470   docker.io/library/httpd   latest
e06c3dbbfe23   docker.io/library/httpd   2.2

$ podman images --format "table {{.ID}}:{{.Tag}}\t{{.Repository}}"
IMAGE ID:TAG          REPOSITORY
d4a07e6ce470:latest   docker.io/library/httpd
e06c3dbbfe23:2.2      docker.io/library/httpd
```

Like Docker, podman uses [Go templates](https://golang.org/pkg/text/template/), which you can use to manipulate the output format of certain commands and log drivers.

## Tagging images

- Check out the **podman-tag** man page:

```
$ man docker-tag
```

- Tag the image "httpd" as "apache":

```
$ podman tag httpd apache
```

- Make sure that **podman images** shows the new tag:

```
$ podman images
REPOSITORY                TAG      IMAGE ID       CREATED         SIZE
docker.io/library/httpd   latest   d4a07e6ce470   12 days ago     137 MB
localhost/apache          latest   d4a07e6ce470   12 days ago     137 MB
docker.io/library/httpd   2.2      e06c3dbbfe23   15 months ago   180 MB
```

Note, that **IMAGE ID** is identical for *apache:latest* and *httpd:latest* container images. The actual consumed storage space has not increased.

- Tag the httpd image with tag 2.2 as apache:v2.2:

```
$ podman tag httpd:2.2 apache:v2.2
$ podman images
REPOSITORY                TAG      IMAGE ID       CREATED         SIZE
localhost/apache          latest   d4a07e6ce470   12 days ago     137 MB
docker.io/library/httpd   latest   d4a07e6ce470   12 days ago     137 MB
docker.io/library/httpd   2.2      e06c3dbbfe23   15 months ago   180 MB
localhost/apache          v2.2     e06c3dbbfe23   15 months ago   180 MB
```

## Getting image information

- Check the **podman-history** man page:

```
$ man podman-history
```

- Display the history of httpd image:

```
$ podman history httpd
ID             CREATED       CREATED BY                                      SIZE      COMMENT
d4a07e6ce470   12 days ago   /bin/sh -c #(nop) CMD ["httpd-foreground"]      0B        
<missing>      12 days ago   /bin/sh -c #(nop) EXPOSE 80                     0B        
<missing>      12 days ago   /bin/sh -c #(nop) COPY file:8b68ac010cb13f...   302B      
<missing>      12 days ago   /bin/sh -c set -eux; savedAptMark="$(apt-m...   16.55MB   
<missing>      12 days ago   /bin/sh -c #(nop) ENV APACHE_DIST_URLS=htt...   16.55MB   
<missing>      12 days ago   /bin/sh -c #(nop) ENV HTTPD_PATCHES=            16.55MB   
<missing>      12 days ago   /bin/sh -c #(nop) ENV HTTPD_SHA256=b4ca9d0...   16.55MB   
<missing>      12 days ago   /bin/sh -c #(nop) ENV HTTPD_VERSION=2.4.39      16.55MB   
<missing>      2 weeks ago   /bin/sh -c set -eux; apt-get update; apt-g...   10.34MB   
<missing>      2 weeks ago   /bin/sh -c #(nop) WORKDIR /usr/local/apache2    10.34MB   
<missing>      2 weeks ago   /bin/sh -c mkdir -p "$HTTPD_PREFIX" && cho...   155B      
<missing>      2 weeks ago   /bin/sh -c #(nop) ENV PATH=/usr/local/apac...   155B      
<missing>      2 weeks ago   /bin/sh -c #(nop) ENV HTTPD_PREFIX=/usr/lo...   155B      
<missing>      2 weeks ago   /bin/sh -c #(nop) CMD ["bash"]                  155B      
<missing>      2 weeks ago   /bin/sh -c #(nop) ADD file:4fc310c0cb879c8...   22.5MB
```

- Let's view the history of *mariadb* and *centos:7* images:

```
$ podman history mariadb
$ podman history centos:7
```

Note! You may need to pull the images first.

- Check out the **podman-inspect** man page:

```
$ man podman-inspect
```

- Inspect the httpd image:

```
$ podman inspect httpd

```

For better clarity, pipe the JSON output to python JSON parser module to get it formatted:

```
$ podman inspect httpd | python -m json.tool
```

- Display environment variables for the httpd image:

```
$ podman inspect -f {{.ContainerConfig.Env}} httpd
[PATH=/usr/local/apache2/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin HTTPD_PREFIX=/usr/local/apache2 HTTPD_VERSION=2.4.39 HTTPD_SHA256=b4ca9d05773aa59b54d66cd8f4744b945289f084d3be17d7981d1783a5decfa2 HTTPD_PATCHES= APACHE_DIST_URLS=https://www.apache.org/dyn/closer.cgi?action=download&filename=    https://www-us.apache.org/dist/    https://www.apache.org/dist/    https://archive.apache.org/dist/]
```


## Removing and untagging images

- Check the **podman-rmi** man page

```
$ man podman-rmi
```

- Display local images

```
$ podman images
REPOSITORY                  TAG      IMAGE ID       CREATED         SIZE
docker.io/library/mariadb   latest   97df12fa9319   12 days ago     375 MB
docker.io/library/httpd     latest   d4a07e6ce470   12 days ago     137 MB
localhost/apache            latest   d4a07e6ce470   12 days ago     137 MB
docker.io/library/centos    7        9f38484d220f   4 weeks ago     209 MB
**docker.io/library/httpd     2.2      e06c3dbbfe23   15 months ago   180 MB**
**localhost/apache            v2.2     e06c3dbbfe23   15 months ago   180 MB**
```

Make sure that image IDs are the same for **httpd:2.2** and **apache:v2.2** images

- Untag the image apache:v2.2:

```
$ podman rmi apache:v2.2
Untagged: localhost/apache:v2.2

$ podman images
REPOSITORY                  TAG      IMAGE ID       CREATED         SIZE
docker.io/library/mariadb   latest   97df12fa9319   12 days ago     375 MB
docker.io/library/httpd     latest   d4a07e6ce470   12 days ago     137 MB
localhost/apache            latest   d4a07e6ce470   12 days ago     137 MB
docker.io/library/centos    7        9f38484d220f   4 weeks ago     209 MB
docker.io/library/httpd     2.2      e06c3dbbfe23   15 months ago   180 MB
```

Make sure that image tagged apache:v2.2 is no longer on the list.

Note that the output of **untag** command mentioned *Untagged*. The actual consumed storage space has not changed.

- Delete image *httpd:2.2* and make sure that all image layers have been deleted:

```
$ podman rmi httpd:2.2
e06c3dbbfe239c6fca50b6ab6935b3122930fa2eea2136979e5b46ad77ecb685

$ podman images
REPOSITORY                  TAG      IMAGE ID       CREATED       SIZE
docker.io/library/mariadb   latest   97df12fa9319   12 days ago   375 MB
docker.io/library/httpd     latest   d4a07e6ce470   12 days ago   137 MB
localhost/apache            latest   d4a07e6ce470   12 days ago   137 MB
docker.io/library/centos    7        9f38484d220f   4 weeks ago   209 MB
```

Note that this time *Untagged* wasn't present in the output of **untag** operation. That means that the actual image has been removed and storage consumption has decreased.


- Untag the apache:latest image:

```
$ podman rmi apache
Untagged: localhost/apache:latest

$ podman images
REPOSITORY                  TAG      IMAGE ID       CREATED       SIZE
docker.io/library/mariadb   latest   97df12fa9319   12 days ago   375 MB
docker.io/library/httpd     latest   d4a07e6ce470   12 days ago   137 MB
docker.io/library/centos    7        9f38484d220f   4 weeks ago   209 MB
```
