#!/bin/bash
echo "Removing old storage"
rm -rf /data/wp_html
rm -f /data/wp_db

echo "Creating new storage"
mkdir -p /data/wp_html
chcon -t container_file_t /data/wp_html

mkdir -p /data/wp_db
chcon -t container_file_t /data/wp_db
