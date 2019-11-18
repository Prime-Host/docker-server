# docker-server
skript to install docker and other software for Ubuntu 18.04 LTS


Change these Variables:
```bash
export P_DOMAIN=example.com && export P_MAIL=info@example.com && export P_PASSWORD="MyAwesomePassword"
```

One Liner install all:
```bash
apt-get install -y git && mkdir /root/docker && cd /root/docker && git clone https://github.com/Prime-Host/docker-server.git && cd docker-server && chmod +x install.sh && bash install.sh
```
