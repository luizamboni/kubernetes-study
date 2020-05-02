Kubernetes Vagrant Cluster
===
This project intent to up a little Kubernetes cluster environment in local machine host.


# Table of Contents
* [Dependencies](#dependencies)
* [How use it](#how-use-it)
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


## How to
### Acess internal service using kubernetes proxy:
http://localhost:**PROXY_PORT**/api/v1/namespaces/**NAMESPACE**/services/**SERVICE**:**PORT**/proxy/

Nginx Example:[http://localhost:8001/api/v1/namespaces/default/services/nginx:80/proxy/](http://localhost:8001/api/v1/namespaces/default/services/nginx:80/proxy/)

### Use example of ingress

Add cafe.example.com resolution to public ip addres in your /etc/hosts
```shell
$ sudo echo "192.168.0.17  cafe.example.com" >>  /etc/hosts
```

# Roadmap
* generate certificates before run `kubeadm init`
