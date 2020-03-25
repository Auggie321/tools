#!/bin/bash
# after deploy_proxy.sh, then you can choose add proxy for docker
# docker version 18.05; os centos 7

folder="/etc/systemd/system/docker.service.d"
file="/etc/systemd/system/docker.service.d/http-proxy.conf"
docker_env_service='[Service]'
docker_env='Environment="HTTP_PROXY=http://127.0.0.1:8118/" "HTTP_PROXY=http://127.0.0.1:8118/" "NO_PROXY=localhost,127.0.0.0,127.0.1.1,127.0.1.1,local.home"'
function operate() {
    echo $docker_env_service > $file
    echo $docker_env >> $file
    chmod +x $file
    systemctl daemon-reload && systemctl restart docker
    #systemctl show --property=Environment docker
    echo `systemctl show --property=Environment docker`
    docker pull gcr.io/google_containers/pause-amd64:3.0
    if [ $? -ne 0 ];then
        echo "docker add proxy failed"
        exit 1
    else
        echo "docker add proxy sucessfully"
        #reboot
        exit 0
    fi
}

if [ ! -d "$folder" ] && [ ! -f "$file" ]; then
    mkdir -p "$folder"
    touch "$file"
    operate
elif [ -d "$folder" ] && [ ! -f "$file" ]; then
    touch "$file"
    operate
elif [ -d "$folder" ] && [ -f "$file" ]; then
    operate
fi