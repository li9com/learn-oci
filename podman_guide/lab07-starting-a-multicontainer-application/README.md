# Lab8 - Starting multicontainer application
In this lab you will start 2-tier application - WordPress.  WordPress is a PHP application, which requires access to a MySQL database.

## Starting a database

- Start a new pod with a single mariadb container as **root**:

```
# podman run -d --pod new:blog -p 8080:80 --name mariadb \
-e MYSQL_USER=wpuser \
-e MYSQL_PASSWORD=wppass \
-e MYSQL_DATABASE=wpdb \
-e MYSQL_ROOT_PASSWORD=secret \
mariadb
9e773d3c5f045e5604ca3b4858a0f3d2367dd8d22d9f0a4bee5bc87912ca5a94
```

Notice that we published port 80/tcp (HTTP) inside the container as 8080/tcp on the host. That is because port binding are shared between all containers in a pod and therefore are defined on pod level.

- Starting wordpress container in the same pod, as the database:

```
# podman run -d --pod blog --name wordpress wordpress
10b2ce94f9aeddb0eb3cf6e0222ab345d1aa613aad5a56dd796070a7f2563138
```

- Let's make sure we have 2 containers within the same pod:

```
# podman pod ps --ctr-names --ns
POD ID         NAME   STATUS    CREATED         CGROUP          NAMESPACES           CONTAINER INFO                                INFRA ID
cb6019bf9625   blog   Running   5 minutes ago   machine.slice   net,ipc,cgroup,uts   [wordpress] [mariadb] [cb6019bf9625-infra]    e0f5850061be
```

Notice that the containers share the same net namespaces. This means that they can communicate with each other through localhost and they share all port bindings and network interfaces.

- Open the wordpress start page at `http://172.24.0.11:8080` via your web browser from your vagrant host, **not** the VM.

- Provide the same database details that you used when starting mariadb container. Make sure you specify *localhost:3306* as *Database Host*.

- Provide other information, such as *Site Title*, *Username*, and *Password*.

- Press *Install WordPress*.

- Finally, you are presented with WordPress login page.

- Let's check that data are indeed present in the database:

```
# podman exec -it mariadb mysql -uwpuser -pwppass wpdb -e "show tables"
+-----------------------+
| Tables_in_wpdb        |
+-----------------------+
| wp_commentmeta        |
| wp_comments           |
| wp_links              |
| wp_options            |
| wp_postmeta           |
| wp_posts              |
| wp_term_relationships |
| wp_term_taxonomy      |
| wp_termmeta           |
| wp_terms              |
| wp_usermeta           |
| wp_users              |
+-----------------------+
```

- Delete the pod to clean-up:

```
# podman pod rm -f blog
be0893de808f5233c7ffa12d388fe49f734fac4887763f66fa1ff5eb919ef53b

# podman pod ps
```
