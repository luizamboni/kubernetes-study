#!/bin/bash
BASEDIR=$(dirname "$0")

$BASEDIR/kubeadm.sh
$BASEDIR/output-join-to-master.sh
$BASEDIR/network-plugin.sh
$BASEDIR/dashboard.sh
$BASEDIR/proxy.sh
$BASEDIR/nginx-ingress.sh