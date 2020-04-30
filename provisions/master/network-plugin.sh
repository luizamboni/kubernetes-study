#!/bin/bash
printf "\n\n[STEP] install network plugin"

## calico (works on amd64 acording)
kubectl apply -f "https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml"
kubectl apply -f "https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml"

sleep 20


printf "\n\n[STEP] wait dns pods is running (WAIT all realy)"
ANY_POD_NOT_RUNNING=$(kubectl get pods --all-namespaces --field-selector=status.phase!=Running)

while [ "$ANY_POD_NOT_RUNNING" != "" ]; do
    echo "PODS RUNNING -------------------------------------------------------------------------------------"
    echo "$ANY_POD_NOT_RUNNING";
    ANY_POD_NOT_RUNNING=$(kubectl get pods --all-namespaces --field-selector=status.phase!=Running)
    sleep 20
done