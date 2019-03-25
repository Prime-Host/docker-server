#!/bin/bash

# install basiscs
apt-get update
apt-get dits-upgrade -y
apt-get install vim htop iftop git curl zsh -y



apt-get install docker.io -y
curl -L https://github.com/docker/compose/releases/download/1.24.0-rc1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp ~/.oh-my-zsh/themes/bira.zsh-theme ~/.oh-my-zsh/themes/prime-host.zsh-theme \
 && sed -i 's/%m%/%M%/g' ~/.oh-my-zsh/themes/prime-host.zsh-theme \
 && sed -i s:~/.oh-my-zsh:\$HOME/.oh-my-zsh:g ~/.zshrc \
 && sed -i 's/robbyrussell/prime-host/g' ~/.zshrc \
 && echo "DISABLE_UPDATE_PROMPT=true" >> ~/.zshrc


echo  "alias dps='docker ps --format "'"'table {{.Names}}\\\\t{{.Image}}\\\\t{{.Status}}\\\\t{{.Size}}'"'" -sa'" >> /root/.zshrc
echo "export HISTFILESIZE=" >> /root/.bashrc
echo "export HISTSIZE=" >> /root/.bashrc


# install oh my zsh with custom theme
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true \
 && cp /root/.oh-my-zsh/themes/bira.zsh-theme /root/.oh-my-zsh/themes/prime-host.zsh-theme \
 && sed -i 's/%m%/%M%/g' /root/.oh-my-zsh/themes/prime-host.zsh-theme \
 && sed -i s:/root/.oh-my-zsh:\$HOME/.oh-my-zsh:g /root/.zshrc \
 && sed -i 's/robbyrussell/prime-host/g' /root/.zshrc \
 && echo "DISABLE_UPDATE_PROMPT=true" >> /root/.zshrc \
 && echo "set encoding=utf-8" >> /root/.vimrc \
 && echo "set fileencoding=utf-8" >> /root/.vimrc \
 && cp -r /root/.oh-my-zsh /etc/skel/. \
 && cp /root/.zshrc /etc/skel/. \
 && cp /root/.vimrc /etc/skel/. \
 && chsh -s $(which zsh)
 
 

#install netdata monitoring
docker pull netdata/netdata
docker run -d --name=netdata \
  --net="webproxy" \
  --restart always \
  -h node002.legendary-server.de \
  -e TZ="Europe/Berlin" \
  -e "VIRTUAL_HOST"="stats.node002.legendary-server.de" \
  -e "LETSENCRYPT_HOST"="stats.node002.legendary-server.de" \
  -e "LETSENCRYPT_EMAIL"="info@nordloh-webdesign.de" \
  -e "VIRTUAL_PORT"="19999" \
  -e PGID=999 \
  -p 19999:19999 \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  --cap-add SYS_PTRACE \
  --security-opt apparmor=unconfined \
  netdata/netdata

#disable swap
swapoff -a
