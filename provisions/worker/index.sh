#!/bin/bash

sudo modprobe ip_vs ip_vs_rr ip_vs_wrr ip_vs_sh

# join in the cluster 
sudo kubeadm join $master_ip:6443 \
        --token $token \
        --discovery-token-unsafe-skip-ca-verification \
        --node-name $HOSTNAME \
        # --ignore-preflight-errors=all