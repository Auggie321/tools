#!/bin/bash
# functions: raspberrypi npc deamon process port 22,3389
# 9092-树莓派3389：	    nohup ./npc -server xxx.xxx.107.xxx:8024 -vkey=7lwsqss8tl7jk9ld &
# 9093-树莓派22：		nohup ./npc -server xxx.xxx.107.xxx:8024 -vkey=dtbk1hzth2z12bvf &
# crontab -l
# */2 * * * *  /bin/bash /opt/npc/raspberrypi.sh


9092sm3389() {
    ps -ef|grep npc|grep 7lwsqss8tl7jk9ld >> /dev/null 2>&1
    if [ $? == 0 ]; then
        echo '树莓派9092-3389正常' >/dev/null 2>&1
    else
        cd /opt/npc
        nohup ./npc -server xxx.xxx.107.xxx:8024 -vkey=7lwsqss8tl7jk9ld &
    fi
}

9093sm22() {
    ps -ef|grep npc|grep dtbk1hzth2z12bvf >> /dev/null 2>&1
    if [ $? == 0 ]; then
        echo '树莓派9093-22正常' >/dev/null 2>&1
    else
        cd /opt/npc
        nohup ./npc -server xxx.xxx.107.xxx:8024 -vkey=dtbk1hzth2z12bvf &
    fi
}
9092sm3389
9093sm22