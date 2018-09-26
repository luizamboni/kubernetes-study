
$token = "icdy68.op8oi8tgmf2lgz9n"
$master_ip = "192.168.0.10"
$rootdir = Dir.pwd

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"
 
  config.vm.provision "file", source: "#{$rootdir}/provisions/entrypoint.sh", destination: "$HOME/entrypoint.sh"
  config.vm.provision "docker"
  config.vm.provision "shell", name: "install dependencies", path: "provisions/dependencies.sh"
  
  config.vm.network "private_network", type: "dhcp"


  config.vm.define "master" do | m |

    m.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
    end
    m.disksize.size = '10GB'


    m.vm.network :private_network, ip: $master_ip
    m.vm.network "forwarded_port", guest: 8001, host: 8001
    # m.vm.provision "shell", 
    #                      inline: "./entrypoint.sh master #{$master_ip} #{$token}", 
    #                      privileged: false

    m.vm.provision "shell", inline: "echo $HOME", privileged: false

  end

  config.vm.define "worker" do | m |
    
    m.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 2
    end
    m.disksize.size = '5GB'

    m.vm.network :private_network, ip: "192.168.0.11"

    # worker.vm.provision "shell", 
    #                     inline: "./entrypoint.sh worker #{$master_ip} #{$token}",
    #                     privileged: false
  end
end

# sudo kubeadm init --token icdy68.op8oi8tgmf2lgz9n --token-ttl 0 --node-name master --apiserver-advertise-address 192.168.0.10
# sudo kubeadm join 192.168.0.10:6443 --token icdy68.op8oi8tgmf2lgz9n  --discovery-token-unsafe-skip-ca-verification --node-name worker1
# sudo kubectl proxy --address=192.168.0.11 --port=6443