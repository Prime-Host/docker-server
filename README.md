# docker-server
script to install docker and other software for Ubuntu 20.04 LTS
test
Requirements:
```bash
apt update && apt install -y git
```

Change these Variables:
```bash
export P_DOMAIN=example.com && export P_MAIL=info@example.com && export P_PASSWORD="MyAwesomePassword"
```

One Liner install all:
```bash
 git clone https://github.com/Prime-Host/docker-server.git /root/docker/docker-server && bash /root/docker/docker-server/install.sh
```
