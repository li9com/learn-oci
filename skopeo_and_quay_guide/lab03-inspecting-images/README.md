# Inspecting Images

- Run the following command to inspect a locally stored image:

```
skopeo inspect oci:httpd
```

- The following commands can be used to inspect a remote image from docker.io. Notice that it takes slightly longer to fetch all tags, instead of just 1, like in previous example where we downloaded latest, wchich is implicit:

```
skopeo inspect docker://httpd
skopeo inspect docker://docker.io/httpd
```

- Just as with docker.io, quay.io can also be queried for image manifest:

```
skopeo inspect docker://quay.io/dockerlibrary/httpd
```
