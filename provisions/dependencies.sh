#/bin/bash

swapoff -a
# echo 'Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"' >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

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
sudo apt-get install -y --allow-downgrades kubernetes-cni=0.6.0-00

K8_VERSION=1.11.2-00
# K8_VERSION=1.12.1-02

apt-get install -y --allow-downgrades kubelet=$K8_VERSION kubeadm=$K8_VERSION kubectl=$K8_VERSION

echo "protect from automatic upgrades"
apt-mark hold kubelet kubeadm kubectl

echo "Kubernetes installed"