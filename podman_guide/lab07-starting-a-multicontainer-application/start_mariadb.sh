#!/bin/bash

podman run -d --pod new:blog -p 8080:80 --name mariadb \
-e MYSQL_USER=wpuser \
-e MYSQL_PASSWORD=wppass \
-e MYSQL_DATABASE=wpdb \
-e MYSQL_ROOT_PASSWORD=secret \
mariadb


