#!/bin/bash

if [ "$1" = 'master' ]; then

  printf "current user: $USER"
  
  kubeadm config images pull

  printf "\n\n[STEP] init master"
  sudo kubeadm init --apiserver-advertise-address $2 \
    --token $3 \
    --token-ttl 0 \
    --node-name master \
    --pod-network-cidr=192.168.0.0/16


  ## set config to kube
  printf "\n\n[STEP] put file in config path"
  mkdir -p $HOME/.kube
  sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
 
  printf "\n\n[STEP] install network plugin"
  
  ## weave
  #sudo sysctl net.bridge.bridge-nf-call-iptables=1
  #kubectl apply -f kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

  ## or calico (works on amd64 acording)
  kubectl apply -f "https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml"
  kubectl apply -f "https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml"
  
  sleep 20

  printf "\n\n[STEP] wait dns pods is running (WAIT all realy)"
  ANY_POD_NOT_RUNNING=$(kubectl get pods --all-namespaces --field-selector=status.phase!=Running)
  while [ "$ANY_POD_NOT_RUNNING" != "" ]; do
    echo "$ANY_POD_NOT_RUNNING";
    ANY_POD_NOT_RUNNING=$(kubectl get pods --all-namespaces --field-selector=status.phase!=Running)
    sleep 20
  done



  kubectl taint nodes --all node-role.kubernetes.io/master-


  printf "\n\n[STEP] create and start UI"
  # create and start UI
  kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
  
  # create account for UI
  kubectl create serviceaccount dashboard -n default
  # binding roles to account 
  kubectl create clusterrolebinding dashboard-admin -n default \
    --clusterrole=cluster-admin \
    --serviceaccount=default:dashboard

  # up UI
  kubectl proxy --address='0.0.0.0' &


  printf "open in browser: \nhttp://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login\n"
  
  UI_TOKEN=$(kubectl get secret $(kubectl get serviceaccount dashboard -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode)
  printf "use token auth: \n$UI_TOKEN\n"

  kubectl get nodes

  kubectl create deployment nginx --image=nginx
fi

if [ "$1" = 'worker' ]; then
  # join in the cluster 
  kubeadm join $2:6443 \
        --token $3 \
        --discovery-token-unsafe-skip-ca-verification \
        --node-name worker \
        --ignore-preflight-errors=all
fi
