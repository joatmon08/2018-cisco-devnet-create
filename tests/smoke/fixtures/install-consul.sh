#!/bin/bash

function isinstalled {
  if yum list installed "$@" >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

function isactive {
  if systemctl is-active "$@" >/dev/null 2>&1; then
    echo "$@ IS ON"
  else
    systemctl start "$@"
  fi
}

yum -y update && yum -y upgrade

echo "=== INSTALLING CONSUL ==="
wget https://releases.hashicorp.com/consul/1.0.6/consul_1.0.6_linux_amd64.zip
unzip consul_1.0.6_linux_amd64.zip
mv consul /usr/bin/
echo "" > /tmp/consul_watch.log

echo $'[Unit]
Description=consul

[Service]
ExecStart=/usr/bin/consul agent -config-file /opt/consul/config/config.json -server -dev -ui -client 0.0.0.0

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/consul.service

echo "=== CONFIGURE CONSUL ==="
yum -y install git
mkdir -p /opt/consul/config && chmod 777 /opt/consul/config
git clone -b artifacts https://github.com/joatmon08/docker-consul-handler.git /opt/consul/config
chmod +x /opt/consul/config/handler

echo "=== INSTALLED CONSUL ==="
exit 0
