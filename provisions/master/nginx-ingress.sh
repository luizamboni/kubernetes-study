#!/bin/bash

git clone https://github.com/nginxinc/kubernetes-ingress/
git checkout v1.7.0


# namespace and account service
kubectl apply -f kubernetes-ingress/deployments/common/ns-and-sa.yaml

# cluster role
kubectl apply -f kubernetes-ingress/deployments/rbac/rbac.yaml

# secret with tls cert data
kubectl apply -f kubernetes-ingress/deployments/common/default-server-secret.yaml


# Create a config map for customizing NGINX configuration:
kubectl apply -f kubernetes-ingress/deployments/common/nginx-config.yaml

# Create custom resource definitions for VirtualServer and VirtualServerRoute and TransportServer resources
kubectl apply -f kubernetes-ingress/deployments/common/vs-definition.yaml
kubectl apply -f kubernetes-ingress/deployments/common/vsr-definition.yaml
kubectl apply -f kubernetes-ingress/deployments/common/ts-definition.yaml


# if you would like to use the TCP and UDP load balancing features of the Ingress Controller, create the following additional resources:

# Create a custom resource definition for GlobalConfiguration resource:
kubectl apply -f kubernetes-ingress/deployments/common/gc-definition.yaml

# Create a GlobalConfiguration resource:
kubectl apply -f kubernetes-ingress/deployments/common/global-configuration.yaml



#Use Deployment or DaemonSet
## Use a Deployment. When you run the Ingress Controller by using a Deployment, by default, Kubernetes will create one Ingress controller pod.
# kubectl apply -f deployment/nginx-ingress.yaml
# kubectl create -f service/nodeport.yaml

## Use a DaemonSet: When you run the Ingress Controller by using a DaemonSet, Kubernetes will create an Ingress controller pod on every node of the cluster.
### See also: See the Kubernetes DaemonSet docs to learn how to run the Ingress controller on a subset of nodes instead of on every node of the cluster.
kubectl apply -f kubernetes-ingress/deployments/daemon-set/nginx-ingress.yaml
kubectl create -f kubernetes-ingress/deployments/service/nodeport.yaml



# coffe example
kubectl apply -f kubernetes-ingress/examples/complete-example/cafe.yaml
kubectl apply -f kubernetes-ingress/examples/complete-example/cafe-secret.yaml
kubectl apply -f kubernetes-ingress/examples/complete-example/cafe-ingress.yaml

