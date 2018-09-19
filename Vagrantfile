
$script = <<-BASH

# Install kubernetes
apt-get update && apt upgrade
apt install snapd -y
snap install conjure-up --classic
conjure-up kubernetes
BASH

Vagrant.configure("2") do |config|
  # Specify your hostname if you like
  # config.vm.hostname = "name"
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", type: "dhcp"
  config.vm.provision "docker"
  config.vm.provision "shell", inline: $script
end