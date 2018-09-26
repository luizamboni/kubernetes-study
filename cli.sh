#!/bin/bash


if [ "$1" = 'build' ]; then
  vagrant up

  vagrant snapshot save master master_init_state
  vagrant snapshot save worker worker_init_state

  vagrant snapshot list
fi

if [ "$1" = 'restore' ]; then
  vagrant snapshot restore master master_init_state --no-provision
  vagrant snapshot restore worker worker_init_state --no-provision
fi

if [ "$1" = 'clean' ]; then
  vagrant snapshot delete  master_init_state
  vagrant snapshot delete worker_init_state

  vagrant destroy -f
fi