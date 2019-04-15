#!/bin/bash
podman rm -f mariadb wordpress
rm -rf /data/wp_html
rm -rf /data/wp_db
