#!/bin/bash
BASEDIR=$(dirname "$0")

$BASEDIR/kubeadm.sh
$BASEDIR/network-plugin.sh
$BASEDIR/dashboard.sh
$BASEDIR/up-dashboard.sh
$BASEDIR/nginx-deployment.sh