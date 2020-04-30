#!/bin/bash
BASEDIR=$(dirname "$0")

$BASEDIR/swapoff.sh
$BASEDIR/disable-ipv6.sh
$BASEDIR/docker.sh
$BASEDIR/kubernetes.sh