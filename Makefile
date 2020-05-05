BUILD_DIR=(shell pwd)

build:
	vagrant up master --no-provision && \
	vagrant provision master --provision-with variables && \
	vagrant provision master --provision-with dependencies && \
	vagrant snapshot save master master_init_state --force && \
	vagrant snapshot list

restore:
	vagrant snapshot restore master master_init_state --no-provision


start:
	vagrant up

stop:
	vagrant halt

clean:
	vagrant destroy -f

start-master:
	vagrant provision master --provision-with start

destroy-workers:
	vagrant destroy worker-0 -f \
	vagrant destroy worker-1 -f


start-worker-0:
	vagrant up worker-0 --no-provision && \
	vagrant provision worker-0 --provision-with variables && \
	vagrant provision worker-0 --provision-with dependencies && \
	vagrant provision worker-0 --provision-with start

start-worker-1:
	vagrant up worker-1 --no-provision && \
	vagrant provision worker-1 --provision-with variables && \
	vagrant provision worker-1 --provision-with dependencies && \
	vagrant provision worker-1 --provision-with start