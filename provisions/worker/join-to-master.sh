#!/bin/bash

# join in the cluster 
sudo kubeadm join $master_ip:6443 \
        --token $token \
        --discovery-token-unsafe-skip-ca-verification \
        --node-name $HOSTNAME \
