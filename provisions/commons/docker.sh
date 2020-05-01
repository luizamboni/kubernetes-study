#!/bin/bash
sudo apt-get remove docker docker-engine docker.io containerd runc  docker-ce docker-ce-cli -y

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -


sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update

sudo apt-cache madison docker-ce

VERSION_STRING='17.03.0~ce-0~ubuntu-xenial'
sudo apt-get install docker-ce=$VERSION_STRING -y

sudo usermod -aG docker vagrant
