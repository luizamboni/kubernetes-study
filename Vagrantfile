
$token = "icdy68.op8oi8tgmf2lgz9n"
$master_ip = "192.168.99.20"
$rootdir = Dir.pwd

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"

  # minimal, disk can be only increased.
  config.disksize.size = '5GB'

  # add file entrypoint.sh
  config.vm.provision "entrypoint", 
          type: "file",
          source: "#{$rootdir}/provisions/entrypoint.sh", 
          destination: "$HOME/entrypoint.sh",
          run: "never"

  
  # install the last docker version
  config.vm.provision "docker", type: "docker", run: "never"


  # install kubelet, kubectl and kubeadm
  config.vm.provision "dependencies", 
           type: "shell", 
           path: "provisions/dependencies.sh",
           run: "never"


  config.vm.define "master" do | m |
    # m.vm.hostname "master"
    m.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
    end

    m.disksize.size = '10GB'

    m.vm.network :private_network, ip: $master_ip
    m.vm.network "forwarded_port", guest: 8001, host: 8001
    m.vm.provision "start",
                   type: "shell", 
                   inline: "./entrypoint.sh master #{$master_ip} #{$token}", 
                   privileged: false,
                   run: "never"

  end

  config.vm.define "worker" do | m |

    # m.vm.hostname "worker"
    m.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 2
    end

    m.vm.network :private_network, ip: "192.168.99.21"

    m.vm.provision "start", 
                    type: "shell", 
                    inline: "./entrypoint.sh worker #{$master_ip} #{$token}",
                    privileged: false,
                    run: "never" 
  end
end

# sudo kubeadm init --token icdy68.op8oi8tgmf2lgz9n --token-ttl 0 --node-name master --apiserver-advertise-address 192.168.99.20
# sudo kubeadm join 192.168.99.20:6443 --token icdy68.op8oi8tgmf2lgz9n  --discovery-token-unsafe-skip-ca-verification --node-name worker1
