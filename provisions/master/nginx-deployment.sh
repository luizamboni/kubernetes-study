#!/bin/bash


kubectl apply -f https://k8s.io/examples/application/deployment-scale.yaml


# kubectl create deployment nginx --image=nginx
kubectl create service nodeport nginx --tcp=80:80
