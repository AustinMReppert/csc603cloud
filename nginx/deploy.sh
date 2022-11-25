#!/bin/bash
set -x

cp /local/repository/nginx/nginx.conf .
sed -i "s/MYDOMAIN/$(hostname -f)/g" nginx.conf

sudo apt-get update && sudo apt-get install -y nginx
sudo cp -f nginx.conf /etc/nginx/nginx.conf
sudo systemctl restart nginx
