#!/bin/bash
SERVER=$(cat /etc/hostname)

cd /root/docker/docker-server/netdata
git pull origin master
export P_PGID=$(grep docker /etc/group | cut -d ':' -f 3)
env $(cat /var/docker-data/env/traefik.${SERVER}.env) docker-compose pull
env $(cat /var/docker-data/env/traefik.${SERVER}.env) docker-compose -p stats.${SERVER} up -d
