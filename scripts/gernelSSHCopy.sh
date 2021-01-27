#!/bin/bash

# Function: copy ssh-copyid from ansible node to others with scripts;
# Supported platform: Centos7.x
# LastUpdate: 2021.1.27
# Author: Auggie

check_ssh() {
    if [ -f "$HOME/.ssh/id_rsa.pub" ]; then
    echo "家目录$HOME已存在id_rsa.pub已存在"
    else
    echo "家目录$HOME已存在id_rsa.pub不存在，免密创建"
    ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
    fi
}

check_package() {
    if [ ! -e "/usr/bin/expect" ]; then
        /usr/bin/yum -y install expect >/dev/null
    else
        echo "expect已经安装"
    fi
}

SERVERS="root@172.30.3.71 root@172.30.3.72 root@172.30.3.73 \
root@172.30.3.74 root@172.30.3.75 "
PASSWORD=ucchip

#将本机生成的公钥复制到其他机子上,如果（yes/no）则自动选择yes继续下一步
#如果password:怎自动将PASSWORD写在后面继续下一步
auto_ssh_copy_id(){
    expect -c "set timeout -1;
    spawn ssh-copy-id $1;                                
    expect {
            *(yes/no)* {send -- yes\r;exp_continue;}
            *password:* {send -- $2\r;exp_continue;}  
            eof        {exit 0;}
    }";
}

ssh_copy_id_to_all(){
    for SERVER in $SERVERS #遍历要发送到各个主机的ip
    do
            auto_ssh_copy_id $SERVER $PASSWORD
    done
}

check_ssh
# check_package
ssh_copy_id_to_all