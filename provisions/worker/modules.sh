!#/bin/bash

echo "ip_vs"              >> /etc/modules-load.d/modules.conf
echo "ip_vs_rr"           >> /etc/modules-load.d/modules.conf
echo "ip_vs_wrr"          >> /etc/modules-load.d/modules.conf
echo "ip_vs_sh"           >> /etc/modules-load.d/modules.conf
echo "nf_conntrack_ipv4"  >> /etc/modules-load.d/modules.conf