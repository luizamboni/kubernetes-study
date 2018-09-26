Kubernetes Vagrant Cluster
===
This project intent to up a little Kubernetes cluster environment in local machine host.


# Table of Contents
* [Dependencies](#dependencies)
* [How use it](#how-use-it)


# Dependencies

## List
* Vagrant
* VirtualBox (actualy)
* vagrant-disksize vagrant plugin

## vagrant-disksize plugin
vagrant plugin install vagrant-disksize


# How use it
## Create images, up then and take snapshots
```bash
$ ./cli build
```
After, can enter in **VMs**
```bash
# to enter in master
$ vagrant ssh master
# to enter in worker
$ vagrant ssh worker
```


## Restore initial images
```bash
$ ./cli restore
```
## Destroy images and snapshots
```bash
$ ./cli restore
```