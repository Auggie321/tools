#!/bin/bash

## 执行备份
datetag=`date +%Y%m%d_%H%M%S`

### mongodump
### 备份本机的yapi-mongo容器内yapi数据库，在本地保存一份/opt/docker/yapi/data/db/${datetag}Backup.gz；
### 同时为了防止机器意外宕机，再次将本地的yapi数据库备份文件副本传到10.0.3.1上一份；
docker exec -it yapi-mongo mongodump -h localhost --port 27017 -u root -p abcPasswd --archive=/data/db/${datetag}Backup.gz --gzip -d=yapi
scp /opt/docker/yapi/data/db/${datetag}Backup.gz root@10.0.3.1:/yapiBackup

##每周天凌晨备份crontab -e
#0 4 * * 7 /bin/bash /opt/docker/yapi/scripts/1BackupYapi.sh

### mongorestore ####################
##全新的mongo数据库；
#example： docker exec -it yapi-mongo mongorestore -h localhost --port 27017 -u root -p abcPasswd --gzip --db yapi --archive=/data/db/20210324_103501Backup.gz

##已经有数据的yapi数据库恢复；
#example: docker exec -it yapi-mongo mongorestore -h localhost --port 27017 -u root -p abcPasswd --gzip --db yapi --drop --archive=/data/db/20210324_103501Backup.gz
#####################################