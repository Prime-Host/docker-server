#!/bin/bash

# install basiscs
apt-get update
apt-get dits-upgrade -y
apt-get install vim htop iftop git curl zsh -y

# install docker requirments and add repo
apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual -y
apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# install docker version with rancher support
apt-get install docker-ce=17.06.2~ce-0~ubuntu

# install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# dps alias for better overview of containers
echo  "alias dps='docker ps --format "'"'table {{.ID}}\\\\t{{.Names}}\\\\t{{.Image}}\\\\t{{.Status}}\\\\t{{.Size}}'"'" -sa'" >> /root/.zshrc

echo "export HISTFILESIZE=" >> /root/.bashrc
echo "export HISTSIZE=" >> /root/.bashrc

# install oh my zsh with bira theme
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sed -i -- 's/robbyrussell/bira/g' /root/.zshrc
