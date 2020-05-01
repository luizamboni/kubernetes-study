#!/bin/bash

printf "\n\n[STEP] init master"
printf "\n\ntoken ttl: $token"
printf "\napiserver-advertise-address: $master_ip"

sudo kubeadm init --apiserver-advertise-address $master_ip \
    --token $token \
    --token-ttl 0 \
    --node-name master \
    --pod-network-cidr=192.168.0.0/16

## set config to kube
printf "\n\n[STEP] put file in config path"
mkdir -p $vagrant_dir/.kube 
sudo cp -f /etc/kubernetes/admin.conf $vagrant_dir/.kube/config
sudo chown vagrant:vagrant $vagrant_dir/.kube/config

mkdir -p /vagrant/.kube
sudo cp -f /etc/kubernetes/admin.conf /vagrant/.kube/config
sudo chown $(id -u):$(id -g) /vagrant/.kube/config


printf "\n\n[STEP] make marter node as worker"
kubectl taint nodes --all node-role.kubernetes.io/master-
