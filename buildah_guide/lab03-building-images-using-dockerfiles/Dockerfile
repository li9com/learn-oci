FROM centos:7

LABEL created-by "Aleksey Usov" \
      lab-directory buildah-guide/lab03-building-images-using-dockerfiles/README.md

RUN yum -y update >/dev/null 2>&1 && \
    yum -y --setopt tsflags=nodocs install httpd >/dev/null 2>&1 && \
    yum clean all

COPY ./index.html /var/www/html

EXPOSE 80

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
