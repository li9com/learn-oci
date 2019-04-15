# Copying images
- Run the following command to copy httpd image from Docker Hub locally in OCI-compliant directory layout:

```
skopeo copy docker://httpd oci:httpd
```

- Run the following command to copy httpd image you downloaded in previous step to your Docker Hub repository:

```
skopeo copy --dest-creds <HUB_USERNAME>:<HUB_PASSWORD> oci:httpd docker://docker.io/<HUB_REPO>/httpd:dev
```

- Go to [Docker Hub](https://hub.docker.com/), sign in to your account, and navigate to <HUB_REPO> to observe the result of copy operation.

- The command below will copy the httpd image tagged as dev in <HUB_REPO> to <QUAY_REPO> in [Quay Registry](https://quay.io) and tag it as qa:

```
skopeo copy --src-creds <HUB_USERNAME>:<HUB_PASSWORD> --dest-creds <QUAY_USERNAME>:<QUAY_PASSWORD> docker://docker.io/<YOUR_REPO>/httpd:dev docker://quay.io/<QUAY_REPO>/httpd:qa
```
