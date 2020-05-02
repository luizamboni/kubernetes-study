#!/bin/bash

# sudo echo "ip_vs"              >> /etc/modules-load.d/modules.conf
# sudo echo "ip_vs_rr"           >> /etc/modules-load.d/modules.conf
# sudo echo "ip_vs_wrr"          >> /etc/modules-load.d/modules.conf
# sudo echo "ip_vs_sh"           >> /etc/modules-load.d/modules.conf
# sudo echo "nf_conntrack_ipv4"  >> /etc/modules-load.d/modules.conf


sudo modprobe ip_vs ip_vs_rr ip_vs_wrr ip_vs_sh
