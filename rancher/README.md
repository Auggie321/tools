```
https://rancher.com/docs/rke/latest/en/managing-clusters/

You can add/remove only worker nodes, by running rke up --update-only. 
This will ignore everything else in the cluster.yml except for any worker nodes.
```

```
rke k8s部署根据官方要求需要普通用户安装操作，使用普通用户操作；
钉钉群文档-成都办公室表格详细信息；
```

```
增加:  
1、增加master、worker节点，直接修改cluster.yml,运行rke up --update-only
2、增加etcd节点，需要修改cluster.yml,执行etcd恢复操作，运行rke up --update-only

删除：  
1、删除master、worker节点，直接执行kubectl delete node 即可
2、删除etcd节点，需要修改cluster.yml,执行etcd恢复操作，运行rke up --update-only
```