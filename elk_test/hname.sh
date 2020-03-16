#!/bin/bash

HostArr=("elk1" "elk2" "elk3")
IpArr=("192.168.60.101" "192.168.60.102" "192.168.60.103")
# HostArr=(elk1 elk2 elk3)
# IpArr=(192.168.60.101 192.168.60.102 192.168.60.103)

a=`cat /etc/hosts|grep 192.168.60.*|wc -l`
if [ $a == 0 ]; then
    for ((i=0;i<3;i++)); do
        echo "${IpArr[$i]} ${HostArr[$i]} " >> /etc/hosts
    done
else
    echo "/etc/hosts already have hostname and ip relations"
fi