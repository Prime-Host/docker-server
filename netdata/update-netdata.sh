#!/bin/bash
SERVER=$(cat /etc/hostname)
export P_PGID=$(grep docker /etc/group | cut -d ':' -f 3)

cd /root/docker/docker-server/netdata
env $(cat /docker/env/traefik.${SERVER}.env) docker-compose pull
env $(cat /docker/env/traefik.${SERVER}.env) docker-compose -p stats.${SERVER} up -d
