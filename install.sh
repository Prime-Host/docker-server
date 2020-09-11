#!/bin/bash

# update & install packages
apt-get update
apt-get dist-upgrade -y
apt-get install vim htop iftop curl wget zsh apt-transport-https ca-certificates gnupg-agent software-properties-common -y
sysctl -w net.core.netdev_budget_usecs=6000

# install docker and docker-compose
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io
curl -L "https://github.com/docker/compose/releases/download/1.27.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
systemctl enable docker
docker network create web

# change hostname and create folders
echo ${P_DOMAIN} > /etc/hostname 
mkdir -p /var/docker/env /var/docker/container /var/docker/traefik

# create env files for traefik and netdata
echo "P_USER=admin" > /var/docker/env/traefik.${P_DOMAIN}.env
{ echo P_CRYPT && openssl passwd -apr1 ${P_PASSWORD}; } | paste -d"=" -s >> /var/docker/env/traefik.${P_DOMAIN}.env
echo "P_DOMAIN=${P_DOMAIN}" > /var/docker/env/traefik.${P_DOMAIN}.env
echo "P_MAIL=${P_MAIL}" > /var/docker/env/traefik.${P_DOMAIN}.env

# install traefik and netdata
touch /var/docker/traefik/acme.json
chmod 600 /var/docker/traefik/acme.json
cd /root/docker/docker-server
export P_PGID=$(grep docker /etc/group | cut -d ':' -f 3)
env $(cat /var/docker/env/traefik.${P_DOMAIN}.env) docker-compose -p traefik.${P_DOMAIN} up -d

# install oh-my-zsh and change theme
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
chsh -s $(which zsh)
cp ~/.oh-my-zsh/themes/bira.zsh-theme ~/.oh-my-zsh/themes/prime-host.zsh-theme \
 && sed -i 's/%m/%M/g' ~/.oh-my-zsh/themes/prime-host.zsh-theme \
 && sed -i s:~/.oh-my-zsh:\$HOME/.oh-my-zsh:g ~/.zshrc \
 && sed -i 's/robbyrussell/prime-host/g' ~/.zshrc \
 && sed -i 's/# DISABLE_UPDATE_PROMPT="true"/DISABLE_UPDATE_PROMPT="true"/g' ~/.zshrc \
 && sed -i 's/plugins=(git)/plugins=(git git-extras docker docker-compose)/g' ~/.zshrc 

# docker ps alias and longer history
echo "alias dps='docker ps --format "'"'table {{.Names}}\\\\t{{.Image}}\\\\t{{.Status}}\\\\t{{.Size}}'"'" -sa'" >> /root/.zshrc
echo "export HISTFILESIZE=" >> /root/.bashrc
echo "export HISTSIZE=" >> /root/.bashrc
