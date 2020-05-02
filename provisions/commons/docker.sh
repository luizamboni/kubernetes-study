#!/bin/bash
sudo apt-get remove docker docker-engine docker.io containerd runc docker-ce docker-ce-cli -y --quiet

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -


sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update

# sudo apt-cache madison docker-ce

DOCKER_VERSION='5:19.03.8~3-0~ubuntu-xenial'
sudo apt-get install docker-ce=$DOCKER_VERSION docker-ce-cli=$DOCKER_VERSION containerd.io -y

sudo usermod -aG docker vagrant
