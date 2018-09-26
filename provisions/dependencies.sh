#/bin/bash

echo "Disabling IPv6"
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p


# Install kubernetes
apt-get update && apt-get install -y apt-transport-https curl

# add kubernetes repository disponible
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list
apt-get update

# install kubernetes tools
apt-get install -y kubelet kubeadm kubectl

echo "protect from automatic upgrades"
apt-mark hold kubelet kubeadm kubectl
kubeadm config images pull

echo "Kubernetes installed"

# network plungin
