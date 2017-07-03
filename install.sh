#!/bin/bash

# install basiscs
apt-get update
apt-get upgrade -y
apt-get install vim htop iftop git curl zsh -y

# install oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# install docker version with rancher support
curl https://releases.rancher.com/install-docker/17.03.sh | sh

# install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.14.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# alias for better overview
echo "alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Size}}" -sa'" >> /root/.zsh_aliases

echo "export HISTFILESIZE=" >> /root/.bashrc
echo "export HISTSIZE=" >> /root/.bashrc
