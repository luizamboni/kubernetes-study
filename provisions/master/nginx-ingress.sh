#!/bin/bash

kubectl create -f $vagrant_dir/provisions/manifests/nginx-ingress/commons.yaml

sleep 5 

kubectl create -f $vagrant_dir/provisions/manifests/nginx-ingress/nginx-ingress.yaml

sleep 10

kubectl create -f $vagrant_dir/provisions/manifests/nginx-ingress/coffe-ingress-example.yaml
