#!/bin/bash
podman run -d -p 5000:5000 \
  -v /data/registry:/var/lib/registry \
  --restart always \
  --name registry \
  registry:2
