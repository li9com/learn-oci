# Lab6 - Using environment variables
This document is the lab related to podman environment variables.

## Starting MariaDB container

- Try to start a mariadb container as **root**:

```
# podman run --rm mariadb
error: database is uninitialized and password option is not specified 
  You need to specify one of MYSQL_ROOT_PASSWORD, MYSQL_ALLOW_EMPTY_PASSWORD and MYSQL_RANDOM_ROOT_PASSWORD
```

Note! It is expected that the container fails with error message, as initialization script in its ENTRYPOINT requires several environment variables.

- Open container documentation using the following link:

```
https://hub.docker.com/_/mariadb
```

- Scroll down to the *Environment Variables* section.

- Try to start a mariadb container by passing *MYSQL_ROOT_PASSWORD* environment variable:

```
# podman run -d --name mariadb -e MYSQL_ROOT_PASSWORD=qwerty mariadb
db0247b62420753e5f38d2ddf8a21680118509e9c97447c572c37245ce92e3e6

# podman ps
CONTAINER ID  IMAGE                             COMMAND               CREATED         STATUS             PORTS  NAMES
db0247b62420  docker.io/library/mariadb:latest  docker-entrypoint...  25 seconds ago  Up 24 seconds ago         mariadb
```

- Check the container's logs:

```
# podman logs mariadb
Initializing database
...
2019-04-15 13:35:38 0 [Note] mysqld: ready for connections.
Version: '10.3.14-MariaDB-1:10.3.14+maria~bionic'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  mariadb.org binary distribution
```

Note! Container has started successfully this time.

- Try to access MariaDB console using container tools:

```
# podman exec -it mariadb mysql -uroot -pqwerty
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 8
Server version: 10.3.14-MariaDB-1:10.3.14+maria~bionic mariadb.org binary distribution

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
+--------------------+
3 rows in set (0.002 sec)

MariaDB [(none)]> exit
**Bye**
```

- Delete all containers

```
# podman rm -af
db0247b62420753e5f38d2ddf8a21680118509e9c97447c572c37245ce92e3e6
```

- Start a mariadb container with the following settings

Parameter           | Value
------------------- | -----
MYSQL_ROOT_PASSWORD | secret
MYSQL_USER          | dbuser
MYSQL_PASSWORD      | dbpassword
MYSQL_DATABASE      | db1

```
# podman run -d --name mariadb \
  -e MYSQL_ROOT_PASSWORD=secret \
  -e MYSQL_USER=dbuser \
  -e MYSQL_PASSWORD=dbpassword \
  -e MYSQL_DATABASE=db1 \
  mariadb

246e4ba8cfc843cb0c83a1d2abb9f230c988c0d2c58975c773dec4200d030102
```

- Check the container's status:

```
# podman ps
CONTAINER ID  IMAGE                             COMMAND               CREATED         STATUS             PORTS  NAMES
246e4ba8cfc8  docker.io/library/mariadb:latest  docker-entrypoint...  43 seconds ago  Up 42 seconds ago         mariadb
```

- Try to access MariaDB service using dbuser:

```
# podman exec mariadb mysql -udbuser -pdbpassword -e "show databases;" db1
Database
db1
information_schema
```

Note! You should be able to access the mariadb service using dbuser.

- Remove all containers

```
# podman rm -af
246e4ba8cfc843cb0c83a1d2abb9f230c988c0d2c58975c773dec4200d030102
```
