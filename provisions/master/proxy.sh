#!/bin/bash

# up UI
kubectl proxy --address='0.0.0.0' &

printf "open in browser: \nhttp://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login\n"


UI_TOKEN=$(kubectl get secret $(kubectl get serviceaccount dashboard -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode)
printf "use token auth: \n$UI_TOKEN\n"