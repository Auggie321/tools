#!/bin/bash
## Centos7.x mini

function DeployRedis() {
    if [ ! -f ./usr/local/src/redis-4.0.1.tar.gz ]; then
           ##redis国内镜像站https://mirrors.huaweicloud.com/redis/
           yum -y install wget gcc net-tools
           wget -P /usr/local/src/ https://mirrors.huaweicloud.com/redis/redis-4.0.1.tar.gz
        fi
        cd /usr/local/src
        tar -xf /usr/local/src/redis-4.0.1.tar.gz
        cd redis-4.0.1
        make PREFIX=$InsPATH install
        mkdir -p $InsPATH/{etc,var,data}
        rsync -avz redis.conf  $InsPATH/etc/
        mv $InsPATH/etc/redis.conf  $InsPATH/etc/redis.conf.bak
        #sed -i 's@pidfile.*@pidfile /var/run/redis-server.pid@' $InsPATH/etc/redis.conf
        #sed -i "s@logfile.*@logfile /usr/local/redis/var/redis.log@" $InsPATH/etc/redis.conf
        #sed -i "s@^dir.*@dir /usr/local/redis/var@" $InsPATH/etc/redis.conf
        #sed -i 's/^daemonize.*/daemonize yes/g' $InsPATH/etc/redis.conf
        #sed -i 's/^# bind 127.0.0.1/bind 0.0.0.0/g' $InsPATH/etc/redis.conf
}

function Sentinel() {
    mkdir -p $InsPATH/data/sentinel
    cd $InsPATH/etc
cat > sentinel.conf<<EOF
port 26379
pidfile "$InsPATH/var/redis-sentinel.pid"
dir "$InsPATH/data/sentinel"
daemonize yes
protected-mode yes
bind 0.0.0.0
logfile "$InsPATH/var/redis-sentinel.log"
sentinel monitor redisMaster $MASTERIP 6379 2
sentinel down-after-milliseconds redisMaster 10000
sentinel failover-timeout redisMaster 60000
sentinel auth-pass redisMaster auggie321
EOF
}

function SyetemctlRedis() {
cat > /etc/systemd/system/redis-server.service<<EOF
[Unit]
Description=Redis-Server
After=network.target

[Service]
ExecStart=$InsPATH/bin/redis-server $InsPATH/etc/redis.conf --daemonize no
ExecStop=$InsPATH/bin/redis-cli -p 6379 shutdown

[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/redis-sentinel.service<<EOF
[Unit]
Description=Redis-Sentinel
After=network.target

[Service]
ExecStart=$InsPATH/bin/redis-sentinel $InsPATH/etc/sentinel.conf --daemonize no
ExecStop=$InsPATH/bin/redis-cli -p 26379 shutdown

[Install]
WantedBy=multi-user.target
EOF
}


##redis安装目录设定和Master ip
InsPATH=/usr/local/redis
MASTERIP=192.168.60.212

##执行脚本
DeployRedis
Sentinel
SyetemctlRedis  ##systemctl xxx redis-server,redis-sentinel
ln -s $InsPATH/bin/redis-cli /usr/local/bin/redis-cli