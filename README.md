Kubernetes Vagrant Cluster
===
This project intent to up a little Kubernetes cluster environment in local machine host.


# Table of Contents
* [Dependencies](#dependencies)
* [How use it](#how-use-it)
* [Kubernetes entities](#kubernetes-entities)
* [How To](#how-to)
* [Roadmap](#roadmap)


# Dependencies

## List
* Vagrant
* VirtualBox (actualy)
* vagrant plugins

# Uefi workaround
[virtualBox-secure-boot-ubuntu-fail.html](virtualBox-secure-boot-ubuntu-fail.html)
Original posted [here] 
(https://stegard.net/2016/10/virtualbox-secure-boot-ubuntu-fail/)

# vagrant plugin
vagrant plugin install vagrant-disksize


# How use it
## Create images, up then and take snapshots
```bash
$ make build
$ make start-master
```
open with browser: [http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login)
and login with token showed in output of master provision

After, in **worker** VM
```bash
# to enter in worker
$ vagrant ssh worker
```
and run the `kubeadm join` command as showed in output of `make start-master`

## Restore initial images
```bash
$ make restore
```
## Destroy images and snapshots
```bash
$ make clean
```

# Kubernetes Entities

## Cluster
 - a set of nodes
## node
  - each machina in cluster

## Pod
- pod is a basic unit of work, it be one or more conteiners 
- grouped for use of same resources as network interface and volumes.

## Workloads
### Services
- group of pods based on a selector
- can have a clusterIp 
- pretend to be as act as a loadbancer
- can be exposeds by
  - nodePort
  - loadBalancer (specific to clouds)
  - externalName
  - externalIp

### Deployments
- mantain n number of pods up across the cluster (by ReplicaSet)
- control rollback or deployment strategies

### DaemonSet
- its like Deployments
- but maintain a minimum number of pods across each cluster Node


## How to
### Acess internal service using kubernetes proxy:
http://localhost:**PROXY_PORT**/api/v1/namespaces/**NAMESPACE**/services/**SERVICE**:**PORT**/proxy/

Nginx Example:[http://localhost:8001/api/v1/namespaces/default/services/nginx:80/proxy/](http://localhost:8001/api/v1/namespaces/default/services/nginx:80/proxy/)

### Use example of ingress

Add cafe.example.com resolution to public ip addres in your /etc/hosts
```shell
$ sudo echo "192.168.0.17  cafe.example.com" >>  /etc/hosts
```
or use curl forcing resolve domain to ip
```shell
$ curl -k --resolve cafe.example.com:172.42.42.100 https://cafe.example.com/coffee
# -k option is to accept self sign certificate
```

### Volume Example
has get in https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/
apply the manifest

```shell
kubectl apply -f manifests/volume/local-volume.yaml
```

enter in pod and try access nginx

```shell
kubectl exec -it task-pv-pod -- /bin/bash
...
apt update && apt install curl -y
curl localhost
```

the content tha you see is the file in provisions/valumes/index.html
try change this file and see what happens :)


```shell
$ kubectl delete pod task-pv-pod
$ kubectl delete pvc task-pv-claim
$ kubectl delete pv task-pv-volume
```

# Network Model
inside any pod you can access other pod directly by it ip and port service

```shell
$ wget -O - 192.168.219.77:8080
# supose that 192.168.219.77 is a pod ip
```

can too access a service ip tha act as a load balancer
```shell
$ wget -O - 10.98.254.52:80
# supose that 10.98.254.52 is a service clusterIp
```

using internal dns server to get a clusterIp of service

```shell
$ nslookup  coffee-svc.default.svc.cluster.local
$ wget -O - coffee-svc.default.svc.cluster.local
# or
$ wget -O - coffee-svc.default.svc
$ wget -O - coffee-svc.default
$ wget -O - coffee-svc # if are in same namespace

# if the service has other namespaces
$ wget -O - nginx-ingress.nginx-ingress
```
## Using NetworkPolicy

apply manifest policy that only allow
traffic from app:nginx-ingress to app:tea 


```shell
# first add a label in nignx-ingress namespace
# it is needed to be used in networ kpolicy
$ kubectl label namespaces nginx-ingress layer=ingress

$ apply -f manifests/networkpolicy/tea-only-allow-ngin-ingress.yaml
```

```shell
$ kubectl delete networkpolicy backend-access-ingress  -n default
```

```
$ kubectl exec -it nginx-ingress-29gr4  /bin/sh --namespace=nginx-ingress
```



# Roadmap
* generate certificates before run `kubeadm init`
