# zookeeper 3.7.0 on k8s

## 1.build docker images from Dokcerfile
[jdk download page](https://adoptium.net/releases.html?variant=openjdk11&jvmVariant=hotspot)
     download a jdk which you choose, unzip it,and relpace jdk in Dockerfile.
```
      docker build /buildPath -f -t -t kube-zookeeper:3.7.0-2
```
## 2.tag docker image
```
      docker tag kube-zookeeper:3.7.0-2 yourhub.com/library/kube-zookeeper:3.7.0-2
```
## 3.docker push image to you hub
```
      docker push youhub.com/library/kube-zookeeper:3.7.0-2
```
## 4.modify repository from zk.yml
```
-         image: harbor.yehangfan.com/library/kube-zookeeper:3.7.0-2
+         image: youhub.com/library/kube-zookeeper:3.7.0-2

```

## 5.create pv reference pvc
 create  user zookeeper and directory on you k8s work node 
```shell
     useradd -u 1002 zookeeper
     mkdir -p  /mnt/zk-0 /mnt/zk-1 /mnt/zk-2 /mnt/zk-3 /mnt/zk-4 && chown -R 1002:1002 /mnt/zk-*
```
create pv     
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  labels:
    type: local
  name: zookeeper-data-pv1
spec:
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 1Gi
  claimRef:
    apiVersion: v1
    kind: PersistentVolumeClaim
    name: datadir-zookeeper-1
    namespace: default
    resourceVersion: "308680"
  hostPath:
    path: /mnt/zk-1
  persistentVolumeReclaimPolicy: Recycle
  storageClassName: manual
```
## 6.working on k8s
```bash
   kubectl apply -f zk.yml
```
