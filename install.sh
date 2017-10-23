#!/bin/bash

# install basiscs
apt-get update
apt-get dits-upgrade -y
apt-get install vim htop iftop git curl zsh -y

# install docker version with rancher support
apt-get install docker-ce=17.06.2~ce-0~ubuntu

# install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# alias for better overview
echo  "alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Size}}" -sa'" >> /root/.zsh_aliases

echo "export HISTFILESIZE=" >> /root/.bashrc
echo "export HISTSIZE=" >> /root/.bashrc

# install oh my zsh with bira theme
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sed -i -- 's/robbyrussell/bira/g' /root/.zshrc
