#!/bin/bash

# install basiscs
apt-get update
apt-get dits-upgrade -y
apt-get install vim htop iftop curl zsh borgbackup -y

# install docker and docker-compose
apt-get install docker.io -y
curl -L https://github.com/docker/compose/releases/download/1.24.0-rc1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# reduce swap usage
echo "vm.swappiness=10" >> /etc/sysctl.conf

# install let's encrypt and nginx container
git clone https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion.git
cd docker-compose-letsencrypt-nginx-proxy-companion
mv .env.sample .env
PROXY_IP_DOCKER=$(ip addr show ens18 | awk '$1 == "inet" {gsub(/\/.*$/, "", $2); print $2}')
sed -i "s/0.0.0.0/$PROXY_IP_DOCKER/g" .env
sed -i "s:./nginx-data:/var/docker-data/proxy:g" .env
./start.sh

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp ~/.oh-my-zsh/themes/bira.zsh-theme ~/.oh-my-zsh/themes/prime-host.zsh-theme \
 && sed -i 's/%m%/%M%/g' ~/.oh-my-zsh/themes/prime-host.zsh-theme \
 && sed -i s:~/.oh-my-zsh:\$HOME/.oh-my-zsh:g ~/.zshrc \
 && sed -i 's/robbyrussell/prime-host/g' ~/.zshrc \
 && echo "DISABLE_UPDATE_PROMPT=true" >> ~/.zshrc

# docker ps alias and longer history
echo  "alias dps='docker ps --format "'"'table {{.Names}}\\\\t{{.Image}}\\\\t{{.Status}}\\\\t{{.Size}}'"'" -sa'" >> /root/.zshrc
echo "export HISTFILESIZE=" >> /root/.bashrc
echo "export HISTSIZE=" >> /root/.bashrc
