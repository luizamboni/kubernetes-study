BUILD_DIR=(shell pwd)

build:
	vagrant up master --no-provision && \
	vagrant provision master --provision-with variables,dependencies && \
	vagrant snapshot save master master_init_state --force && \
	vagrant snapshot list

restore:
	vagrant snapshot restore master master_init_state --no-provision

clean:
	vagrant destroy -f && \
	vagrant snapshot delete master_init_state
	

start-master:
	vagrant provision master --provision-with variables,start
