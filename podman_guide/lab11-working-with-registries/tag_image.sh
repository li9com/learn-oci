#!/bin/bash
podman pull httpd
podman tag httpd localhost:5000/apache
