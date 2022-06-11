# doris-on-k8s

# 前言

当前使用**hostNetWork**方式部署。包括：1个FE，1个BE。

说明：

- hostNetwork方式（目前部署方式）

  优点：PodIP都是节点IP，不用每次ADD BACKEND。保证了Doris服务的连续性。

  缺点：每个节点只能启动一个BE，因为对于同Deployment下的hostNetwork: true启动的Pod，每个node上只能启动一个。

# 部署步骤

## 1.修改pv.yaml

下载四个yaml，**将FE-pv.yaml，BE-pv.yaml中的节点亲和性，修改成自己集群的node**。或删除节点亲和性相关配置。

```
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - node-010000000233
```

修改后执行命令即可完成FE、BE的部署

```shell
kubectl apply -f FE-pv.yaml
kubectl apply -f FE-deployment.yaml
kubectl apply -f BE-pv.yaml 
kubectl apply -f BE-deployment.yaml
```


## 2. 添加BE到FE

执行完查看doris服务，启动正常

![img](https://intranetproxy.alipay.com/skylark/lark/0/2021/png/13456375/1640153315318-55e7f8aa-062d-4cf0-a99a-a1fd03645094.png)

添加BE到FE

```yaml
#连接FE，172.16.0.161换成自己的节点IP
mysql -h172.16.0.161 -P9030 -uroot
SHOW PROC '/backends';
#添加BE，如果Alive=true，添加成功
ALTER SYSTEM ADD BACKEND "172.16.0.161:9050";
```

![img](https://intranetproxy.alipay.com/skylark/lark/0/2021/png/13456375/1640153257035-4725cc76-c171-4f83-9c51-ca563b66fae4.png)

BE已添加，可正常使用Doris

**至此doris on k8s部署结束**。后续使用请参考官方文档：https://doris.apache.org/master/zh-CN/installing/compilation.html







