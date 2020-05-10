#!/bin/bash
BASEDIR=$(dirname "$0")

# up UI
kubectl proxy --address='0.0.0.0' &

printf "open in browser: \nhttp://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login\n"

$BASEDIR/show-service-account-dashboard-token.sh 