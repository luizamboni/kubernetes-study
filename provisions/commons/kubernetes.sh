#!/bin/bash

# Install kubernetes
apt-get update && apt-get install -y apt-transport-https curl -y

# add kubernetes repository disponible
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list
apt-get update

# install kubernetes tools
sudo apt-get install -y --allow-downgrades kubernetes-cni=0.6.0-00

K8_VERSION=1.11.2-00

apt-get install -y --allow-downgrades kubelet=$K8_VERSION kubeadm=$K8_VERSION kubectl=$K8_VERSION

echo "protect from automatic upgrades"
apt-mark hold kubelet kubeadm kubectl

echo "Kubernetes installed"