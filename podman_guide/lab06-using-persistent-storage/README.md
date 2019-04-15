# Lab7 - Using persistent storage
In this lab, you will start containers on a persistent storage. Due to limitations of a non-privileged user, we will be working as **root** in this lab.

## Apache service
In this chapter, we will be using another Apache image, which is OpenShift-ready. The image name is *httpd-24-centos7*.

- Pull *docker.io/centos/httpd-24-centos7* image:

```
podman pull docker.io/centos/httpd-24-centos7
```

- Start an httpd container to make sure that it works:

```
# podman run -d --name httpd -p 8080:8080 httpd-24-centos7
717f85c48d4d1ae8d116be99b8cc61f50f12124ad4934113b4180772c6a0340a

# podman ps
CONTAINER ID  IMAGE                                     COMMAND               CREATED         STATUS             PORTS                   NAMES
717f85c48d4d  docker.io/centos/httpd-24-centos7:latest  container-entrypo...  19 seconds ago  Up 18 seconds ago  0.0.0.0:8080->8080/tcp  httpd
```

- Try to access your application using Web Browser using either http://node1.172.24.0.11.nip.io:8080 or http://172.24.0.11:8080 URL. You should be able to see "Red Hat Enterprise Linux Test Page". This page has been displayed since there is no index.html file in the server's web root.

- Delete the container:

```
# podman rm -af
717f85c48d4d1ae8d116be99b8cc61f50f12124ad4934113b4180772c6a0340a
```

- Inspect the image docker.io/centos/httpd-24-centos7 in order to understand what storage driver is used:

```
# podman inspect httpd-24-centos7 | python -m json.tool
[
    {
        "Annotations": {},
        "Architecture": "amd64",
        "Author": "",
        "Comment": "",
        "ContainerConfig": {
            "Cmd": [
                "/usr/bin/run-httpd"
            ],
            "Entrypoint": [
                "container-entrypoint"
            ],
            "Env": [
                "PATH=/opt/app-root/src/bin:/opt/app-root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "SUMMARY=Platform for running Apache httpd 2.4 or building httpd-based application",
                "DESCRIPTION=Apache httpd 2.4 available as container, is a powerful, efficient, and extensible web server. Apache supports a variety of features, many implemented as compiled modules which extend the core functionality. These can range from server-side programming language support to authentication schemes. Virtual hosting allows one Apache installation to serve many different Web sites.",
                "STI_SCRIPTS_URL=image:///usr/libexec/s2i",
                "STI_SCRIPTS_PATH=/usr/libexec/s2i",
                "APP_ROOT=/opt/app-root",
                "HOME=/opt/app-root/src",
                "PLATFORM=el7",
                "BASH_ENV=/opt/app-root/scl_enable",
                "ENV=/opt/app-root/scl_enable",
                "PROMPT_COMMAND=. /opt/app-root/scl_enable",
                "HTTPD_VERSION=2.4",
                "HTTPD_CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/httpd/",
                "HTTPD_APP_ROOT=/opt/app-root",
                "HTTPD_CONFIGURATION_PATH=/opt/app-root/etc/httpd.d",
                "HTTPD_MAIN_CONF_PATH=/etc/httpd/conf",
                "HTTPD_MAIN_CONF_MODULES_D_PATH=/etc/httpd/conf.modules.d",
                "HTTPD_MAIN_CONF_D_PATH=/etc/httpd/conf.d",
                "HTTPD_VAR_RUN=/var/run/httpd",
                "HTTPD_DATA_PATH=/var/www",
                "HTTPD_DATA_ORIG_PATH=/opt/rh/httpd24/root/var/www",
                "HTTPD_LOG_PATH=/var/log/httpd24",
                "HTTPD_SCL=httpd24"
            ],
            "ExposedPorts": {
                "8080/tcp": {},
                "8443/tcp": {}
            },
            "Labels": {
                "com.redhat.component": "httpd24-container",
                "description": "Apache httpd 2.4 available as container, is a powerful, efficient, and extensible web server. Apache supports a variety of features, many implemented as compiled modules which extend the core functionality. These can range from server-side programming language support to authentication schemes. Virtual hosting allows one Apache installation to serve many different Web sites.",
                "io.k8s.description": "Apache httpd 2.4 available as container, is a powerful, efficient, and extensible web server. Apache supports a variety of features, many implemented as compiled modules which extend the core functionality. These can range from server-side programming language support to authentication schemes. Virtual hosting allows one Apache installation to serve many different Web sites.",
                "io.k8s.display-name": "Apache httpd 2.4",
                "io.openshift.builder-version": "\"576489e\"",
                "io.openshift.expose-services": "8080:http,8443:https",
                "io.openshift.s2i.scripts-url": "image:///usr/libexec/s2i",
                "io.openshift.tags": "builder,httpd,httpd24",
                "io.s2i.scripts-url": "image:///usr/libexec/s2i",
                "maintainer": "SoftwareCollections.org <sclorg@redhat.com>",
                "name": "centos/httpd-24-centos7",
                "org.label-schema.build-date": "20190305",
                "org.label-schema.license": "GPLv2",
                "org.label-schema.name": "CentOS Base Image",
                "org.label-schema.schema-version": "1.0",
                "org.label-schema.vendor": "CentOS",
                "summary": "Platform for running Apache httpd 2.4 or building httpd-based application",
                "usage": "s2i build https://github.com/sclorg/httpd-container.git --context-dir=examples/sample-test-app/ centos/httpd-24-centos7 sample-server",
                "version": "2.4"
            },
            "User": "1001",
            "WorkingDir": "/opt/app-root/src"
        },
        "Created": "2019-04-03T07:25:09.936460149Z",
        "Digest": "sha256:d1256b39182b0ac5290c946dc44fc11055524683113a1b5e3a55d83044a185cb",
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/containers/storage/overlay/a6267d7382817e799a06743bbd1259db083159bbbb3c49b1d3bdb111038490fc/diff:/var/lib/containers/storage/overlay/ff054df09fb765e5f36ca6cc6f3a5815ef9ec02aaf7df17c6706152596702b6f/diff:/var/lib/containers/storage/overlay/829006c2336096d6ec468ffa4114b566e8cf7fb97df272386912958c3ca646be/diff:/var/lib/containers/storage/overlay/0018c6851148ac05d2fd54c49aa3e8f7385399ac2eb0853f42a918a5aa34b473/diff:/var/lib/containers/storage/overlay/12b70e9b19a1c0854b3defbd640f00002138da785c4e7e1fba4bf6dcd72bb9db/diff:/var/lib/containers/storage/overlay/4ec3102a0a6b8b2a7f605905219d42b75c20b40d219b20eae17a64c146eac308/diff:/var/lib/containers/storage/overlay/d69483a6face4499acb974449d1303591fcbb5cdce5420f36f8a6607bda11854/diff",
                "MergedDir": "/var/lib/containers/storage/overlay/b4b34e37c0101ef6374b4e0dc6c4d09a0e92d2e0c3f5c464f71067c414e8b208/merged",
                "UpperDir": "/var/lib/containers/storage/overlay/b4b34e37c0101ef6374b4e0dc6c4d09a0e92d2e0c3f5c464f71067c414e8b208/diff",
                "WorkDir": "/var/lib/containers/storage/overlay/b4b34e37c0101ef6374b4e0dc6c4d09a0e92d2e0c3f5c464f71067c414e8b208/work"
            },
            "Name": "overlay"
        },
        "History": [
            {
                "created": "2019-03-14T21:19:52.66982152Z",
                "created_by": "/bin/sh -c #(nop) ADD file:074f2c974463ab38cf3532134e8ba2c91c9e346457713f2e8b8e2ac0ee9fd83d in / "
            },
            {
                "created": "2019-03-14T21:19:53.099141434Z",
                "created_by": "/bin/sh -c #(nop)  LABEL org.label-schema.schema-version=1.0 org.label-schema.name=CentOS Base Image org.label-schema.vendor=CentOS org.label-schema.license=GPLv2 org.label-schema.build-date=20190305",
                "empty_layer": true
            },
            {
                "created": "2019-03-14T21:19:53.361167852Z",
                "created_by": "/bin/sh -c #(nop)  CMD [\"/bin/bash\"]",
                "empty_layer": true
            },
            {
                "created": "2019-04-03T06:37:51.423833615Z",
                "created_by": "/bin/sh -c #(nop)  ENV SUMMARY=Base image which allows using of source-to-image. DESCRIPTION=The s2i-core image provides any images layered on top of it with all the tools needed to use source-to-image functionality while keeping the image size as small as possible.",
                "empty_layer": true
            },
            {
                "created": "2019-04-03T06:37:51.465772402Z",
                "created_by": "/bin/sh -c #(nop)  LABEL summary=Base image which allows using of source-to-image. description=The s2i-core image provides any images layered on top of it with all the tools needed to use source-to-image functionality while keeping the image size as small as possible. io.k8s.description=The s2i-core image provides any images layered on top of it with all the tools needed to use source-to-image functionality while keeping the image size as small as possible. io.k8s.display-name=s2i core io.openshift.s2i.scripts-url=image:///usr/libexec/s2i io.s2i.scripts-url=image:///usr/libexec/s2i com.redhat.component=s2i-core-container name=centos/s2i-core-centos7 version=1 maintainer=SoftwareCollections.org <sclorg@redhat.com>",
                "empty_layer": true
            },
            {
                "created": "2019-04-03T06:37:51.506266979Z",
                "created_by": "/bin/sh -c #(nop)  ENV STI_SCRIPTS_URL=image:///usr/libexec/s2i STI_SCRIPTS_PATH=/usr/libexec/s2i APP_ROOT=/opt/app-root HOME=/opt/app-root/src PATH=/opt/app-root/src/bin:/opt/app-root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin PLATFORM=el7",
                "empty_layer": true
            },
            {
                "created": "2019-04-03T06:37:51.547799361Z",
                "created_by": "/bin/sh -c #(nop)  ENV BASH_ENV=/opt/app-root/etc/scl_enable ENV=/opt/app-root/etc/scl_enable PROMPT_COMMAND=. /opt/app-root/etc/scl_enable",
                "empty_layer": true
            },
            {
                "created": "2019-04-03T06:38:09.221125344Z",
                "created_by": "/bin/sh -c rpmkeys --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 &&   INSTALL_PKGS=\"bsdtar   findutils   gettext   groff-base   scl-utils   tar   unzip   yum-utils\" &&   mkdir -p ${HOME}/.pki/nssdb &&   chown -R 1001:0 ${HOME}/.pki &&   yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS &&   rpm -V $INSTALL_PKGS &&   yum clean all -y"
            },
            {
                "created": "2019-04-03T06:38:09.308091789Z",
                "created_by": "/bin/sh -c #(nop) COPY dir:65327957eecee4ecfeef5bcdac5953d079d876724efdde34fdbf4c16920d5536 in / "
            },
            {
                "created": "2019-04-03T06:38:09.346472408Z",
                "created_by": "/bin/sh -c #(nop) WORKDIR /opt/app-root/src",
                "empty_layer": true
            },
            {
                "created": "2019-04-03T06:38:09.384798485Z",
                "created_by": "/bin/sh -c #(nop)  ENTRYPOINT [\"container-entrypoint\"]",
                "empty_layer": true
            },
            {
                "created": "2019-04-03T06:38:09.435035222Z",
                "created_by": "/bin/sh -c #(nop)  CMD [\"base-usage\"]",
                "empty_layer": true
            },
            {
                "created": "2019-04-03T06:38:10.728446069Z",
                "created_by": "/bin/sh -c rpm-file-permissions &&   useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin       -c \"Default Application User\" default &&   chown -R 1001:0 ${APP_ROOT}"
            },
            {
                "created": "2019-04-03T06:38:10.778796662Z",
                "created_by": "/bin/sh -c #(nop)  LABEL io.openshift.builder-version=\"b575984\"",
                "empty_layer": true
            },
            {
                "created": "2019-04-03T07:23:12.970615444Z",
                "created_by": "/bin/sh -c #(nop)  ENV HTTPD_VERSION=2.4",
                "empty_layer": true
            },
            {
                "created": "2019-04-03T07:23:13.066659088Z",
                "created_by": "/bin/sh -c #(nop)  ENV SUMMARY=Platform for running Apache httpd 2.4 or building httpd-based application DESCRIPTION=Apache httpd 2.4 available as container, is a powerful, efficient, and extensible web server. Apache supports a variety of features, many implemented as compiled modules which extend the core functionality. These can range from server-side programming language support to authentication schemes. Virtual hosting allows one Apache installation to serve many different Web sites.",
                "empty_layer": true
            },
            {
                "created": "2019-04-03T07:23:13.155022345Z",
                "created_by": "/bin/sh -c #(nop)  LABEL summary=Platform for running Apache httpd 2.4 or building httpd-based application description=Apache httpd 2.4 available as container, is a powerful, efficient, and extensible web server. Apache supports a variety of features, many implemented as compiled modules which extend the core functionality. These can range from server-side programming language support to authentication schemes. Virtual hosting allows one Apache installation to serve many different Web sites. io.k8s.description=Apache httpd 2.4 available as container, is a powerful, efficient, and extensible web server. Apache supports a variety of features, many implemented as compiled modules which extend the core functionality. These can range from server-side programming language support to authentication schemes. Virtual hosting allows one Apache installation to serve many different Web sites. io.k8s.display-name=Apache httpd 2.4 io.openshift.expose-services=8080:http,8443:https io.openshift.tags=builder,httpd,httpd24 name=centos/httpd-24-centos7 version=2.4 com.redhat.component=httpd24-container usage=s2i build https://github.com/sclorg/httpd-container.git --context-dir=examples/sample-test-app/ centos/httpd-24-centos7 sample-server maintainer=SoftwareCollections.org <sclorg@redhat.com>",
                "empty_layer": true
            },
            {
                "created": "2019-04-03T07:23:13.248149366Z",
                "created_by": "/bin/sh -c #(nop)  EXPOSE 8080/tcp",
                "empty_layer": true
            },
            {
                "created": "2019-04-03T07:23:13.353546998Z",
                "created_by": "/bin/sh -c #(nop)  EXPOSE 8443/tcp",
                "empty_layer": true
            },
            {
                "created": "2019-04-03T07:25:07.298934742Z",
                "created_by": "/bin/sh -c yum install -y yum-utils &&     yum install -y centos-release-scl epel-release &&     INSTALL_PKGS=\"gettext hostname nss_wrapper bind-utils httpd24 httpd24-mod_ssl httpd24-mod_auth_mellon\" &&     yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS &&     rpm -V $INSTALL_PKGS &&     yum clean all"
            },
            {
                "created": "2019-04-03T07:25:07.543150352Z",
                "created_by": "/bin/sh -c #(nop)  ENV HTTPD_CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/httpd/ HTTPD_APP_ROOT=/opt/app-root HTTPD_CONFIGURATION_PATH=/opt/app-root/etc/httpd.d HTTPD_MAIN_CONF_PATH=/etc/httpd/conf HTTPD_MAIN_CONF_MODULES_D_PATH=/etc/httpd/conf.modules.d HTTPD_MAIN_CONF_D_PATH=/etc/httpd/conf.d HTTPD_VAR_RUN=/var/run/httpd HTTPD_DATA_PATH=/var/www HTTPD_DATA_ORIG_PATH=/opt/rh/httpd24/root/var/www HTTPD_LOG_PATH=/var/log/httpd24 HTTPD_SCL=httpd24",
                "empty_layer": true
            },
            {
                "created": "2019-04-03T07:25:07.587648619Z",
                "created_by": "/bin/sh -c #(nop)  ENV BASH_ENV=/opt/app-root/scl_enable ENV=/opt/app-root/scl_enable PROMPT_COMMAND=. /opt/app-root/scl_enable",
                "empty_layer": true
            },
            {
                "created": "2019-04-03T07:25:07.663266316Z",
                "created_by": "/bin/sh -c #(nop) COPY dir:f0939949a8b293072e24d8b379c224214d35523195529a38082e780fe7715bcf in /usr/libexec/s2i "
            },
            {
                "created": "2019-04-03T07:25:07.866557786Z",
                "created_by": "/bin/sh -c #(nop) COPY dir:05917c8615f676b78d5fe4878702126b12bb8f16e3d67f037e1f55af9b78f35e in / "
            },
            {
                "created": "2019-04-03T07:25:09.777054215Z",
                "created_by": "/bin/sh -c /usr/libexec/httpd-prepare && rpm-file-permissions"
            },
            {
                "created": "2019-04-03T07:25:09.828814437Z",
                "created_by": "/bin/sh -c #(nop)  USER [1001]",
                "empty_layer": true
            },
            {
                "created": "2019-04-03T07:25:09.889300573Z",
                "created_by": "/bin/sh -c #(nop)  CMD [\"/usr/bin/run-httpd\"]",
                "empty_layer": true
            },
            {
                "created": "2019-04-03T07:25:09.936460149Z",
                "created_by": "/bin/sh -c #(nop)  LABEL io.openshift.builder-version=\"576489e\"",
                "empty_layer": true
            }
        ],
        "Id": "3e99af35821fbc17d8621b0c49284506e50dc471cf2a44c64d538cac2b281020",
        "Labels": {
            "com.redhat.component": "httpd24-container",
            "description": "Apache httpd 2.4 available as container, is a powerful, efficient, and extensible web server. Apache supports a variety of features, many implemented as compiled modules which extend the core functionality. These can range from server-side programming language support to authentication schemes. Virtual hosting allows one Apache installation to serve many different Web sites.",
            "io.k8s.description": "Apache httpd 2.4 available as container, is a powerful, efficient, and extensible web server. Apache supports a variety of features, many implemented as compiled modules which extend the core functionality. These can range from server-side programming language support to authentication schemes. Virtual hosting allows one Apache installation to serve many different Web sites.",
            "io.k8s.display-name": "Apache httpd 2.4",
            "io.openshift.builder-version": "\"576489e\"",
            "io.openshift.expose-services": "8080:http,8443:https",
            "io.openshift.s2i.scripts-url": "image:///usr/libexec/s2i",
            "io.openshift.tags": "builder,httpd,httpd24",
            "io.s2i.scripts-url": "image:///usr/libexec/s2i",
            "maintainer": "SoftwareCollections.org <sclorg@redhat.com>",
            "name": "centos/httpd-24-centos7",
            "org.label-schema.build-date": "20190305",
            "org.label-schema.license": "GPLv2",
            "org.label-schema.name": "CentOS Base Image",
            "org.label-schema.schema-version": "1.0",
            "org.label-schema.vendor": "CentOS",
            "summary": "Platform for running Apache httpd 2.4 or building httpd-based application",
            "usage": "s2i build https://github.com/sclorg/httpd-container.git --context-dir=examples/sample-test-app/ centos/httpd-24-centos7 sample-server",
            "version": "2.4"
        },
        "ManifestType": "application/vnd.docker.distribution.manifest.v2+json",
        "Os": "linux",
        "Parent": "",
        "RepoDigests": [
            "docker.io/centos/httpd-24-centos7@sha256:d1256b39182b0ac5290c946dc44fc11055524683113a1b5e3a55d83044a185cb"
        ],
        "RepoTags": [
            "docker.io/centos/httpd-24-centos7:latest"
        ],
        "RootFS": {
            "Layers": [
                "sha256:d69483a6face4499acb974449d1303591fcbb5cdce5420f36f8a6607bda11854",
                "sha256:cadb33ee445a76091cedc2e18b28792114a018060a63e8a6d405e150528f0c9d",
                "sha256:74029f0a44237c489b0e8008f9a611b93837a19a23ad18778905979173f137ab",
                "sha256:a413cda2d80bdbaabbe50555b4b34fa0d9e0813a36e6b8ef07b41072bb6c49b4",
                "sha256:acf94461c6207d9fe2c76c6b3f11a1a137f1a9f22fc07335b2c2ec9b41af9c56",
                "sha256:b179c6823f45aa3efcaaaaab004169d6fff05bd952ba298cb903b5e410612e57",
                "sha256:767ef2f032ab09fe3899bdc7ed23f8af61838c1060fbdea4060113dd9b9c7187",
                "sha256:4392503673917ca1fc95d7e3dc883f50a4e95dda8fb9e39fa395fd05bca90063"
            ],
            "Type": "layers"
        },
        "Size": 374724986,
        "User": "1001",
        "Version": "1.13.1",
        "VirtualSize": 374724986
    }
]
```

Note! The *HTTPD_DATA_PATH* variable points to */var/www* directory. It looks like persistent storage should be under standard RHEL Apache directory */var/www/html*.

- Create a persistent storage for our Apache container:

```
$ mkdir -p /data/apache
$ chcon -t container_file_t /data/apache
$ chown 1001:0 /data/apache
$ chmod g+s /data/apache
$ echo "Custom page" > /data/apache/index.html
```

Note! We have created a custom directory with *index.html* file in it. We will mount this directory into the new apache containers on start.

- Start 3 apache containers using persistent storage:

```
# podman run -d --name httpd1 -p 8081:8080 -v /data/apache:/var/www/html docker.io/centos/httpd-24-centos7
7db5c333eae4026ca488e29bc9a8086cebdd8db64ed505b3a18d57e3cc0950c4

# podman run -d --name httpd2 -p 8082:8080 -v /data/apache:/var/www/html docker.io/centos/httpd-24-centos7
a9855003d3b771b4d5e7de5c2a1910378bca32a360dca7a91acd236c249be072

# podman run -d --name httpd3 -p 8083:8080 -v /data/apache:/var/www/html docker.io/centos/httpd-24-centos7
fc88a203a7543eb9ce688954be0072fefe76a6ce35d4609105e67954f0d7b686
```

Gather container information:

```
# podman ps
CONTAINER ID  IMAGE                                     COMMAND               CREATED             STATUS                 PORTS                   NAMES
fc88a203a754  docker.io/centos/httpd-24-centos7:latest  container-entrypo...  About a minute ago  Up About a minute ago  0.0.0.0:8083->8080/tcp  httpd3
a9855003d3b7  docker.io/centos/httpd-24-centos7:latest  container-entrypo...  About a minute ago  Up About a minute ago  0.0.0.0:8082->8080/tcp  httpd2
7db5c333eae4  docker.io/centos/httpd-24-centos7:latest  container-entrypo...  About a minute ago  Up About a minute ago  0.0.0.0:8081->8080/tcp  httpd1
```

Gather IP addresses and access apache web services

```
# curl http://$(podman inspect --format='{{ .NetworkSettings.IPAddress }}' httpd1):8080
Custom page
 
# curl http://$(podman inspect --format='{{ .NetworkSettings.IPAddress }}' httpd2):8080
Custom page

# curl http://$(podman inspect --format='{{ .NetworkSettings.IPAddress }}' httpd3):8080
Custom page
```

All containers should return the same data.

- Update *index.html* and make sure that the returned content has changed:

```
# echo "New line" >> /data/apache/index.html

# curl http://$(podman inspect --format='{{ .NetworkSettings.IPAddress }}' httpd1):8080
Custom page
New line

# curl http://$(podman inspect --format='{{ .NetworkSettings.IPAddress }}' httpd2):8080
Custom page
New line

# curl http://$(podman inspect --format='{{ .NetworkSettings.IPAddress }}' httpd3):8080
Custom page
New line
```

- Remove all containers:

```
# podman rm -af
fc88a203a7543eb9ce688954be0072fefe76a6ce35d4609105e67954f0d7b686
7db5c333eae4026ca488e29bc9a8086cebdd8db64ed505b3a18d57e3cc0950c4
a9855003d3b771b4d5e7de5c2a1910378bca32a360dca7a91acd236c249be072
```

## Persistent MariaDB


- Check location of MariaDB data volume:

```
# podman inspect --format='{{ .ContainerConfig.Volumes }}' mariadb
map[/var/lib/mysql:{}]
```

Note! It looks like /var/lib/mysql should be used for the persistent storage.

- Configure mariadb persistent storage:

```
mkdir -p /data/mysql
chcon -t container_file_t /data/mysql
```

- Start a mariadb container:

```
$ podman run -d --name mariadb \
   -v /data/mysql:/var/lib/mysql \
   -e MYSQL_ROOT_PASSWORD=secret \
   -e MYSQL_USER=dbuser \
   -e MYSQL_PASSWORD=dbpassword \
   -e MYSQL_DATABASE=exampledb \
   mariadb
ebe8a264540a77ecec1718ede818598710193c9eb6ba226967f2f746dd2041ce
```

- Check the status:

```
# podman ps
CONTAINER ID  IMAGE                             COMMAND               CREATED         STATUS             PORTS  NAMES
ebe8a264540a  docker.io/library/mariadb:latest  docker-entrypoint...  51 seconds ago  Up 50 seconds ago         mariadb
```

- Make sure that the service works:

```
# podman exec -it mariadb mysql -udbuser -pdbpassword -h127.0.0.1 -e 'show databases;' exampledb
+--------------------+
| Database           |
+--------------------+
| exampledb          |
| information_schema |
+--------------------+
```

- Make sure that database files are stored on the persistent storage:

```
# ls -ln /data/mysql
total 122932
-rw-rw----. 1 999 999    16384 Apr 15 14:26 aria_log.00000001
-rw-rw----. 1 999 999       52 Apr 15 14:26 aria_log_control
drwx------. 2 999 999       20 Apr 15 14:26 exampledb
-rw-rw----. 1 999 999      976 Apr 15 14:26 ib_buffer_pool
-rw-rw----. 1 999 999 12582912 Apr 15 14:26 ibdata1
-rw-rw----. 1 999 999 50331648 Apr 15 14:26 ib_logfile0
-rw-rw----. 1 999 999 50331648 Apr 15 14:25 ib_logfile1
-rw-rw----. 1 999 999 12582912 Apr 15 14:26 ibtmp1
-rw-rw----. 1 999 999        0 Apr 15 14:25 multi-master.info
drwx------. 2 999 999     4096 Apr 15 14:26 mysql
drwx------. 2 999 999       20 Apr 15 14:25 performance_schema
-rw-rw----. 1 999 999    24576 Apr 15 14:26 tc.log
```

- Delete the container and start a new one using the same persistent storage. There is no need to provide environment variables again to create a database and user, since we are re-using the same directory with database data in it:

```
# podman rm -f mariadb
ebe8a264540a77ecec1718ede818598710193c9eb6ba226967f2f746dd2041ce
 
# podman run -d --name mariadb -v /data/mysql:/var/lib/mysql mariadb
b128b653ab25b62d61334f8e3fcd232e1f4e24e0dd43932923369062752f9acb
```

- Confirm that new container is running and that we still have *exampledb* database:

```
# podman ps
CONTAINER ID  IMAGE                             COMMAND               CREATED        STATUS            PORTS  NAMES
b128b653ab25  docker.io/library/mariadb:latest  docker-entrypoint...  6 seconds ago  Up 6 seconds ago         mariadb

# podman exec -it mariadb mysql -udbuser -pdbpassword -h127.0.0.1 -e 'show databases;' exampledb
+--------------------+
| Database           |
+--------------------+
| exampledb          |
| information_schema |
+--------------------+
```

- Delete all containers

```
# podman rm -af
b128b653ab25b62d61334f8e3fcd232e1f4e24e0dd43932923369062752f9acb
```
