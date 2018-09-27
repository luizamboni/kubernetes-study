Kubernetes Vagrant Cluster
===
This project intent to up a little Kubernetes cluster environment in local machine host.


# Table of Contents
* [Dependencies](#dependencies)
* [How use it](#how-use-it)
* [Roadmap](#roadmap)


# Dependencies

## List
* Vagrant
* VirtualBox (actualy)
* vagrant plugins

# vagrant plugin
vagrant plugin install vagrant-disksize

# How use it
## Create images, up then and take snapshots
```bash
$ ./cli build
$ ./cli start-master
```
open with browser: [http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login](http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login)
and login with token showed in output of master provision

After, in **worker** VM
```bash
# to enter in worker
$ vagrant ssh worker
```
and run the `kubeadm join` command as showed in output of `./cli start-master`

## Restore initial images
```bash
$ ./cli restore
```
## Destroy images and snapshots
```bash
$ ./cli restore
```

# Roadmap
* generate certificates before run `kubeadm init`