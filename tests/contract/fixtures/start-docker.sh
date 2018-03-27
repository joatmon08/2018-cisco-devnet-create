function isactive {
  if systemctl is-active "$@" >/dev/null 2>&1; then
    echo "$@ IS ON"
  else
    systemctl start "$@"
  fi
}

echo "=== CONFIGURE DOCKER ==="
mkdir -p /etc/systemd/system/docker.service.d
echo $'[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --cluster-store=consul://127.0.0.1:8500 --cluster-advertise=eth1:2375' > /etc/systemd/system/docker.service.d/override.conf

echo "=== TURNING ON DOCKER ==="
systemctl daemon-reload
systemctl restart docker
isactive "docker"

echo "=== CHECKING DOCKER DAEMON ==="
output=`docker ps`
if [ $? -ne 0 ]; then
    echo "FAILED TO SHOW DOCKER INFORMATION : ${output}"
    exit 1
fi

systemctl enable docker