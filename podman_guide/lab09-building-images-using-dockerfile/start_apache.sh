#!/bin/bash
podman run -d --name httpd -p 8080:80 custom_httpd
