#!/bin/bash

main() {
  if [ "$1" = 'build' ]; then

    main 'clean'
    printf "build image"
    vagrant up --no-provision

    printf "basic provisioning"
    vagrant provision --provision-with docker,dependencies
    vagrant snapshot save master master_init_state --force
    vagrant snapshot save worker worker_init_state --force

    vagrant snapshot list
  fi

  if [ "$1" = 'restore' ]; then
    vagrant snapshot restore master master_init_state --no-provision
    vagrant snapshot restore worker worker_init_state --no-provision
  fi

  if [ "$1" = 'clean' ]; then
    vagrant snapshot delete master_init_state
    vagrant snapshot delete worker_init_state

    vagrant destroy -f
  fi

  if [ "$1" = 'start-master' ]; then
    vagrant provision master --provision-with entrypoint,start
  fi

}

main $1