#!/bin/bash

# Install kubernetes
sudo apt-get update && apt-get install apt-transport-https curl -y -q

# add kubernetes repository disponible
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sudo echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update

# K8_VERSION=1.11.2-00
K8_VERSION=1.18.2-00

# CNI_VERSION=0.6.0-00
CNI_VERSION=0.7.5-00

sudo apt-get install -y --allow-downgrades  \
    kubernetes-cni=$CNI_VERSION \ 
    kubelet=$K8_VERSION \
    kubeadm=$K8_VERSION \
    kubectl=$K8_VERSION

sudo apt-get install -y --allow-downgrades  kubelet=$K8_VERSION kubeadm=$K8_VERSION kubectl=$K8_VERSION


echo "protect from automatic upgrades"
# apt-mark hold kubernetes-cni kubelet kubeadm kubectl

echo "Kubernetes installed"