#!/bin/bash

# install basiscs
apt-get update
apt-get dits-upgrade -y
apt-get install vim htop iftop curl zsh borgbackup -y

# install docker and docker-compose
apt-get install docker.io -y
curl -L https://github.com/docker/compose/releases/download/1.24.0-rc1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# change hostname and reduce swap usage
echo ${P_DOMAIN} > /etc/hostname 
echo "vm.swappiness=10" >> /etc/sysctl.conf

# install let's encrypt and nginx container
git clone https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion.git
cd docker-compose-letsencrypt-nginx-proxy-companion
mv .env.sample .env
PROXY_IP_DOCKER=$(ip addr show ens18 | awk '$1 == "inet" {gsub(/\/.*$/, "", $2); print $2}')
sed -i "s/0.0.0.0/$PROXY_IP_DOCKER/g" .env
sed -i "s:./nginx-data:/var/docker-data/proxy:g" .env
./start.sh

# install netdata container
cd ../netdata
export P_PGID=$(grep docker /etc/group | cut -d ':' -f 3)
docker-compose pull && docker-compose -p ${P_DOMAIN} up -d

# Secure netdata with authentication
sh -c "echo -n 'netdata:' >> /var/docker-data/proxy/htpasswd/stats.${P_DOMAIN}"
sh -c "openssl passwd -apr1 ${P_PASSWORD} >> /var/docker-data/proxy/htpasswd/stats.${P_DOMAIN}"

# install oh-my-zsh and change theme
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed 's:env zsh -l::g' | sed 's:chsh -s .*$::g')"
cp ~/.oh-my-zsh/themes/bira.zsh-theme ~/.oh-my-zsh/themes/prime-host.zsh-theme \
 && sed -i 's/%m%/%M%/g' ~/.oh-my-zsh/themes/prime-host.zsh-theme \
 && sed -i s:~/.oh-my-zsh:\$HOME/.oh-my-zsh:g ~/.zshrc \
 && sed -i 's/robbyrussell/prime-host/g' ~/.zshrc \
 && echo "DISABLE_UPDATE_PROMPT=true" >> ~/.zshrc

# docker ps alias and longer history
echo  "alias dps='docker ps --format "'"'table {{.Names}}\\\\t{{.Image}}\\\\t{{.Status}}\\\\t{{.Size}}'"'" -sa'" >> /root/.zshrc
echo "export HISTFILESIZE=" >> /root/.bashrc
echo "export HISTSIZE=" >> /root/.bashrc

echo "System will now reboot"
sleep 3s
reboot
