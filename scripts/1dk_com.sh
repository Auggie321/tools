#!/bin/bash

# Function: prepare some server's basic enviroment,it consist of docker, pip, docker-compose, chronyCenIns, selinux, ansible;
# Supported platform: Centos7.x Or ubuntu
# LastUpdate: 2021.1.27
# Author: Auggie

##Install aliyun docker-ce
####################Installing a specific version######################################
# Centos
# root@demo3 ~ $ yum list docker-ce --showduplicates|grep "^dock"|sort -r
# docker-ce.x86_64            3:19.03.8-3.el7                     docker-ce-stable
# root@demo3 ~ $  yum -y install docker-ce-19.03.8-3.el7 
#######################################################################################

########################################## mix centos,ubuntu ################################################################
existDaemon() {
    if [ -f /etc/docker/daemon.json ]; then
        echo "/etc/docker/daemon.json already exist"
    elif [ ! -d /etc/docker ]; then
        mkdir -p /etc/docker
        setDaemon
    elif [ -d /etc/docker ]; then
        if   [ ! -f /etc/docker/daemon.json ]; then
            mkdir -p /etc/docker
            setDaemon
        else
            exit 1
        fi
    fi
}

setDaemon() {
    tee /etc/docker/daemon.json<<EOF
{
    "registry-mirrors":["https://q1s6p6vq.mirror.aliyuncs.com"],
    "log-driver": "json-file",
    "log-opts": {
    	"max-size": "50m",
        "max-file": "3"
  }
}
EOF
systemctl daemon-reload;systemctl restart docker;systemctl enable docker
}

addPipRepo() {
cat > ~/.pip/pip.conf<<EOF
[global]
index-url=http://pypi.douban.com/simple

[install]
trusted-host = pypi.douban.com
EOF
}

addComposeBin() {
    ##### python platform issue==> pip install --upgrade pip && pip install 'more-itertools<=5.0.0' 'six>=1.11.0' docker-compose
    # curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)"  -o /usr/local/bin/docker-compose
    wget --no-check-certificate https://www.mxcd.zone/share/package/docker-compose
    chmod +x docker-compose
    mv docker-compose /usr/bin/docker-compose
}

pipCenIns() {
    a=`pip --version >/dev/null 2>&1`
    b=$?
    if [ $b != 0 ]; then
        yum -y install epel-release
        yum -y install python-pip python-devel
        mkdir ~/.pip
        addPipRepo
        addComposeBin
    elif [ $b = 0 ]; then
        if [ -f ~/.pip/pip.conf ]; then
            echo "~/.pip/pip.conf Already Exist"
        else
            mkdir -p ~/.pip
            addPipRepo
            addComposeBin
        fi
    fi
}

sourceCheck () {
    docker --version;docker-compose --version;
    pip --version;systemctl status chronyd
    echo -e "\033[45;37m source /usr/share/bash-completion/completions/docker && source /usr/share/bash-completion/bash_completion \n \033[0m"
}
########################################## mix end ###################################################################################

########################################## centos ##################################################################################
dkCenIns() {
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
        ## yum -y install docker-ce
        yum -y install docker-ce-19.03.8-3.el7 docker-ce-cli-19.03.8-3.el7
        yum -y install gcc gcc-c++ vim wget tree net-tools bash-completion
        systemctl enable docker && systemctl start docker && systemctl status docker
    elif [ $b == 0 ]; then
        echo "Docker Already Exist, `docker --version`"
    fi
}

chronyCenIns() {
    yum -y install chrony
    systemctl enable chrony && systemctl restart chrony
    timedatectl set-timezone Asia/Shanghai
    chronyc tracking
    sed -i  's/SELINUX=enforcing/SELINUX=disabled/g'  /etc/selinux/config
    setenforce 0
}
######################################################## centos end ######################################################



######################################################## ubuntu ###########################################################
dkUbuIns () {
    # https://docs.docker.com/engine/install/ubuntu/
    a=`docker --version >/dev/null 2>&1`
    b=$?
    if [ $b != 0 ]; then
        apt-get remove docker docker-engine docker.io containerd runc -y
        apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common wget tree -y
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        apt-key fingerprint 0EBFCD88
        add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        apt update -y
        ## apt-get install docker-ce docker-ce-cli containerd.io -y
        apt-get install docker-ce=5:19.03.12~3-0~ubuntu-bionic docker-ce-cli=5:19.03.12~3-0~ubuntu-bionic containerd.io  wget -y
        systemctl enable docker && systemctl start docker && systemctl status docker
    elif [ $b == 0 ]; then
        echo "Docker Already Exist, `docker --version`"
    fi
}

packUbuIns () {
    apt install net-tools chrony bash-completion -y
    systemctl enable chrony
    apt remove golang-docker-credential-helpers unattended-upgrades -y
    systemctl stop apt-daily.timer;systemctl disable apt-daily.timer
    systemctl stop apt-daily.service;systemctl disable apt-daily.service
    systemctl stop apt-daily-upgrade.service;systemctl disable apt-daily-upgrade.timer
    systemctl stop apt-daily-upgrade.service;systemctl disable apt-daily-upgrade.service
    chronyc tracking
    timedatectl set-timezone Asia/Shanghai
}

pipUbuIns () {
    a=`pip --version >/dev/null 2>&1`
    b=$?
    if [ $b != 0 ]; then
        apt install python-pip build-essential python-dev python-setuptools -y
        apt install  python3-pip python3-dev  python3-setuptools -y
        addPipRepo
        mkdir ~/.pip
        addPipRepo
        addComposeBin
    elif [ $b = 0 ]; then
        if [ -f ~/.pip/pip.conf ]; then
            echo "~/.pip/pip.conf Already Exist"
        else
            mkdir -p ~/.pip
            addPipRepo
            addComposeBin
        fi
    fi
}

####################################################### ubuntu end ##############################################################

platformCheck () {
    if [ -f /etc/redhat-release ]; then
        release="centos"
    elif cat /etc/issue | grep -Eqi "debian"; then
        release="debian"
    elif cat /etc/issue | grep -Eqi "ubuntu"; then
        release="ubuntu"
    elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
        release="centos"
    elif cat /proc/version | grep -Eqi "debian"; then
        release="debian"
    elif cat /proc/version | grep -Eqi "ubuntu"; then
        release="ubuntu"
    elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
        release="centos"
    else
        release=""
    fi
}


############# execute order ######################################################################################################## 
##01 check platform is ubunut or centos
platformCheck

##02 install docker-ce pip chrony tree wget and package set, and check
if [ $release == "centos" ] ; then
    echo -e "\033[35m ****************************************************************************************** \033[0m"
    echo -e "\033[35m ****************************************************************************************** \033[0m"
    echo -e "\033[35m *********************************Platform for Centos************************************** \033[0m"
    echo -e "\033[35m ****************************************************************************************** \033[0m"
    echo -e "\033[35m ****************************************************************************************** \033[0m"

    dkCenIns
    existDaemon
    pipCenIns
    chronyCenIns
    sourceCheck
    systemctl status firewalld;getenforce
    echo -e "\033[36m ************************************ completed ******************************************** \033[0m"

elif [ $release == "ubuntu" ]; then
    echo -e "\033[35m ****************************************************************************************** \033[0m"
    echo -e "\033[35m ****************************************************************************************** \033[0m"
    echo -e "\033[35m *********************************Platform for Ubuntu************************************** \033[0m"
    echo -e "\033[35m ****************************************************************************************** \033[0m"
    echo -e "\033[35m ****************************************************************************************** \033[0m"

    dkUbuIns
    existDaemon
    packUbuIns
    pipUbuIns
    sourceCheck
    echo -e "\033[36m ************************************ completed ******************************************** \033[0m"

else
    release=""
fi