# 说明

当前部署方式为 hostNetwork，PodIP 即节点 IP，如此可避免BE节点重启BEIP发生变化需重新ADD BACKEND，保证了Doris服务的连续性。

但随之出现的问题是每个k8s节点只能启动一个BE，且每个k8s节点需要为doris预留监听端口，默认：doris-fe(8030、9010、9020、9030)、doris-be(8040、8060、9050、9060、9070)；

当然，如果这些端口在k8s节点上已经被占用，你需要修改doris配置文件中的端口，重新打包镜像。

# 部署

你需要先根据自己的k8s环境修改FE-pvc.yaml 和 BE-pvc.yaml 的创建方式
创建完PVC就可以直接部署FE、BE

```shell
kubectl apply -f doris-pvc.yaml
```
```shell
kubectl apply -f FE-deployment.yaml
kubectl apply -f BE-deployment.yaml
```

# 添加BE到FE

执行完查看doris服务，启动正常

添加BE到FE

```shell
#连接FE，10.168.1.11换成自己的节点IP
mysql -h10.168.1.11 -P9030 -uroot
SHOW PROC '/backends';
#添加BE，如果Alive=true，添加成功
ALTER SYSTEM ADD BACKEND "10.168.1.11:9050";
```



