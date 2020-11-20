#!/bin/bash
#Function: prepare some server's basic enviroment,it consist of docker, pip, docker-compose, chronyd, selinux, ansible;
#Supported system versions: Centos7.x
#Author: Auggie

##Install aliyun docker-ce
DkIns() {
    a=`docker --version >/dev/null 2>&1`
    b=$?
    if [ $b != 0 ]; then
        curl http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -o /etc/yum.repos.d/docker-ce.repo>&/dev/null
        yum remove docker \
        docker-client \
        docker-client-latest \
        docker-common \
        docker-latest
        docker-latest-logrotate \
        docker-logrotate \
        docker-selinx \
        docker-engine-selinux \
        docker-engine >& /dev/null
        yum list docker-ce --showduplicates|grep "^dock"|sort -r
        yum -y install docker-ce gcc gcc-c++ vim
        systemctl enable docker && systemctl start docker && systemctl status docker
    elif [ $b == 0 ]; then
        echo "Docker Already Exist, `docker --version`"
    fi
}

##Aliyun Docker Speed Proxy
DkSpRepo() {
    tee /etc/docker/daemon.json<<EOF
{
    "registry-mirrors":["https://q1s6p6vq.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload && systemctl restart docker
}

##Add aliyun Docker Speed configuration
DkSpeed() {
    if [ -f /etc/docker/daemon.json ]; then
        echo "/etc/docker/daemon.json already exist"
    elif [ ! -d /etc/docker ]; then
        mkdir -p /etc/docker
        DkSpRepo
    elif [ -d /etc/docker ]; then
        if   [ ! -f /etc/docker/daemon.json ]; then
            mkdir -p /etc/docker
            DkSpRepo
        else
            exit 1
        fi
    fi
}

##Add pip speed repo
PipRepo() {
cat >> ~/.pip/pip.conf<<EOF
[global]
index-url=http://pypi.douban.com/simple
trusted-host = pypi.douban.com
EOF
}

##After pip, install docker-compose
DkCom() {
    pip install --upgrade pip
    #python issue,nouseful
    #pip install 'more-itertools<=5.0.0'
    #pip install 'six>=1.11.0'
    #pip install docker-compose
    wget --no-check-certificate https://tool.auggieme.top/share/docker-compose
    chmod +x docker-compose
    mv docker-compose /usr/bin/docker-compose
    
}

##Install pip and add speed configuration
PipIns() {
    a=`pip --version >/dev/null 2>&1`
    b=$?
    if [ $b != 0 ]; then
        yum -y install epel-release
        yum -y install python-pip python-devel
        mkdir ~/.pip
        PipRepo
        DkCom
    elif [ $b = 0 ]; then
        if [ -f ~/.pip/pip.conf ]; then
            echo "~/.pip/pip.conf Already Exist"
        else
            mkdir -p ~/.pip
            PipRepo
            DkCom
        fi
    fi
}

Chrony() {
    yum -y install chrony
    systemctl enable chronyd && systemctl restart chronyd
    timedatectl set-timezone Asia/Shanghai
    chronyc tracking
    sed -i  's/SELINUX=enforcing/SELINUX=disabled/g'  /etc/selinux/config
    setenforce 0
}

Ansb() {
    if [ -f /etc/yum.repos.d/epel.repo ]; then
        yum -y install ansible
    else
        yum -y install epel-release
        yum -y install ansible
    fi
}

##Vps install pip,no need speed
VpsPip() {
    yum -y install epel-release
    yum -y install python-pip python-devel
    DkCom
}

# AnsibleSet() {
#     ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N ''
# }



## Demostic Server Use: Default
DkIns && DkSpeed && PipIns && Ansb && Chrony
docker --version;docker-compose --version;pip --version;systemctl status chronyd;ansible --version;getenforce

# echo "docker,pip,docker-compose,ansible installed finshed"
## VPS Use
# DkIns && VpsPip && Chrony
# docker --version;docker-compose --version;pip --version;systemctl status chronyd;getenforce
