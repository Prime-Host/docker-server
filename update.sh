#!/bin/bash

# update & install basiscs
apt-get update
apt-get dist-upgrade -y
docker network create web

# create env files for traefik and netdata
mkdir -p /var/docker/env /var/docker/container /var/docker/traefik
echo "P_USER=admin" > /var/docker/env/traefik.${P_DOMAIN}.env
{ echo P_CRYPT && openssl passwd -apr1 ${P_PASSWORD}; } | paste -d"=" -s >> /var/docker/env/traefik.${P_DOMAIN}.env

# install traefik and netdata
touch /var/docker/traefik/acme.json
chmod 600 /var/docker/traefik/acme.json
cd /root/docker/docker-server
export P_PGID=$(grep docker /etc/group | cut -d ':' -f 3)
docker pull traefik
docker pull netdata/netdata
env $(cat /var/docker/env/traefik.${P_DOMAIN}.env) docker-compose -p traefik.${P_DOMAIN} up -d
