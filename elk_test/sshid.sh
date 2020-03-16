#!/bin/bash

HostArr=("elk1" "elk2" "elk3")
IpArr=("192.168.60.101" "192.168.60.102" "192.168.60.103")
# HostArr=(elk1 elk2 elk3)
# IpArr=(192.168.60.101 192.168.60.102 192.168.60.103)

for ((i=0;i<3;i++)); do
    echo "${HostArr[$i]}  ${IpArr[$i]}" >> /etc/hosts
    ssh-keyscan -f ~/.ssh/id_rsa.pub ${IpArr[$i]} >> ~/.ssh/known_hosts
    sshpass -p "vagrant" ssh-copy-id root@${IpArr[$i]}
done