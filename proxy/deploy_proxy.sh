#!/bin/bash
# Function: add shadowsocks client and privoxy for centos.
# you better have one vps , shadowsocks.json add your vps ip,passwd.
# please make sure source ~/.bashrc successfully.

yum install epel-release -y
yum groupinstall "Development Tools" -y
yum install -y m2crypto python-setuptools privoxy && easy_install pip && python -m pip install --upgrade pip
python -m pip install --upgrade setuptools
pip install shadowsocks
# input your vps: ip,port,passwd,security-method;
cat >> /etc/shadowsocks.json <<EOF 
{
  "server": "104.207.xx.xx",
  "server_port": 52019,
  "password": "huaclxxxxx",
  "method": "aes-256-cfb",
  "local_address":"127.0.0.1",
  "local_port":1080
}
EOF
#sslocal  -c /etc/shadowsocks.json -d start #重启后会消失,因此将服务添加到system里面
cat > /etc/systemd/system/shadowsocks.service <<EOF
[Unit]
Description=Shadowsocks

[Service]
TimeoutStartSec=0
ExecStart=/usr/bin/sslocal  -c /etc/shadowsocks.json

[Install]
WantedBy=multi-user.target
EOF
systemctl enable shadowsocks
sslocal  -c /etc/shadowsocks.json -d start
echo "forward-socks5t   /               127.0.0.1:1080 . " >> /etc/privoxy/config
echo "127.0.0.1:8118    #listen-address" >> /etc/privoxy/config
echo "export http_proxy=http://127.0.0.1:8118" >> /$USER/.bashrc
echo "export https_proxy=http://127.0.0.1:8118" >> /$USER/.bashrc
echo "export ftp_proxy=http://127.0.0.1:8118" >> /$USER/.bashrc
source /$USER/.bashrc
systemctl restart privoxy.service && systemctl enable privoxy.service
curl www.google.com
if [ $? -ne 0 ];then
    echo "curl google failed"
    exit 0
else
    echo "curl google successfully"
    #reboot
    exit 1
fi