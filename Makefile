BUILD_DIR=(shell pwd)

build:
	vagrant up master --no-provision && \
	vagrant provision master --provision-with variables && \
	vagrant provision master --provision-with dependencies && \
	vagrant snapshot save master master_init_state --force && \
	vagrant snapshot list

restore:
	vagrant snapshot restore master master_init_state --no-provision

clean:
	vagrant destroy -f

start-master:
	vagrant provision master --provision-with start
