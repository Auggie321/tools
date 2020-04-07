### forked from sparanoid/docker-compose-smokeping
添加并修改了如下的东西：  
1.加入了web页面访问,需要输入登录账号admin/admin的功能（默认设置为无账号即可访问）  
如需设置账号登录，可取消docker-compose内htpasswd的一行注释，同时需要把smokeping.conf内不用的配置注释即可；  
2.解决了原代码内部的httpd.conf的一些报错设置  
3.注释了Targets内部没用的节点，并添加了一些自己的数据  
4.修改了Database内部icmp的触发频率  
5.注释了etc/config下的Private文件，暂时无需加密部分配置  

### Built-in Providers
- Google Compute Engine (GCE)
- Amazon Elastic Compute Cloud (EC2)
- Azure Virtual Machines (Azure VM)
- Rackspace Virtual Cloud Servers (VCS)
- Vultr
- Linode
- DigitalOcean

### Usage
- 直观展示DNS和各ISP的ip到本地的网络情况，通过短暂的数据展示，方便选择。也可用作生产公网线路的检测，为方便安全性可考虑LADP
```shell
docker-compose up -d
```
[smokeping官方文档](https://oss.oetiker.ch/smokeping/)  
[smokeping中文简略](https://www.cnblogs.com/netonline/p/7773909.html)

