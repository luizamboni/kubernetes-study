#!/bin/bash

# join in the cluster

cat > /vagrant/join-cmd <<EOF 
#!/bin/bash
sudo kubeadm join $master_ip:6443 \
--token $token \
--discovery-token-ca-cert-hash sha256:$(openssl x509 -in /etc/kubernetes/pki/ca.crt -noout -pubkey | openssl rsa -pubin -outform DER 2>/dev/null | sha256sum | cut -d' ' -f1) \
--node-name \$HOSTNAME
EOF
chmod +x /vagrant/join-cmd
