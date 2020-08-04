三节点redis-sentinel 4.0.1，一主两从，sentinel在每个节点安装；  
redisDeploy.sh脚本还差redis.conf的配置，参照示例已给出,根据实际情况可灵活改动；  

举例三节点：  
master 192.168.60.211   6379 26379  
slave1 192.168.60.212    6379 26379  
slave2 192.168.60.213    6379 26379  

设置默认redis的安装路径为redisDeploy.sh内部的InsPATH=/usr/local/redis；master ip:192.168.60.211(默认防火墙已自行设置)  

ansible all -m copy -a "src=redisDeploy.sh dest=/root/redisDeploy.sh"  
ansible all -m shell -a "bash redisDeploy.sh"  
ansible slave1 -m shell -a 'echo "slaveof 192.168.60.212 6379" >> /usr/local/redis/etc/redis.conf'  
ansible slave2 -m shell -a 'echo "slaveof 192.168.60.213 6379" >> /usr/local/redis/etc/redis.conf'  
ansible all -m shell -a "systemctl enable redis-server;systemctl enable redis-sentinel"  
ansible all -m shell -a "systemctl start redis-server;systemctl start redis-sentinel"  

验证：  
redis-cli -h 192.168.60.211 -p 6379 -a auggie321 info replication  
ansible all -m shell -a 'netstat -tlnup|grep redis'  