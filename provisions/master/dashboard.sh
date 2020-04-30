#!/bin/bash
printf "\n\n[STEP] create and start UI"
# create and start UI
kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.0/src/deploy/recommended/kubernetes-dashboard.yaml

# create account for UI
kubectl create serviceaccount dashboard -n default
# binding roles to account 
kubectl create clusterrolebinding dashboard-admin -n default --clusterrole=cluster-admin --serviceaccount=default:dashboard