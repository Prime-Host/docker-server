#!/bin/bash
SERVER=$(cat /etc/hostname)

# update & install packages
#apt-get update
#apt-get dist-upgrade -y

# update traefik, netdata & phpmyadmin
cd /root/docker/docker-server
git pull origin master
export P_PGID=$(grep docker /etc/group | cut -d ':' -f 3)
env $(cat /var/docker/env/traefik.${SERVER}.env) docker-compose pull
env $(cat /var/docker/env/traefik.${SERVER}.env) docker-compose -p traefik.${SERVER} up -d
