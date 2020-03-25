#!/bin/bash
# uninstall proxy

systemctl stop privoxy && yum remove -y privoxy
sed -i -e '/export http_proxy/d' /$USER/.bashrc
sed -i -e '/export https_proxy/d' /$USER/.bashrc
sed -ie '/export ftp_proxy/d' /$USER/.bashrc
source ~/.bashrc
pip uninstall shadowsocks -y
cat /etc/shadowsocks.json
rm -rf /etc/shadowsocks.json
reboot