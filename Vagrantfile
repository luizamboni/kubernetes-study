require 'ipaddr'

$token = "icdy68.op8oi8tgmf2lgz9n"
$inital_private_ip = IPAddr.new("172.42.42.100")
$initial_public_ip =  IPAddr.new("172.42.42.100")
workers = 2

$vagrant_dir = "/home/vagrant"

$set_environment_variables = <<-SHELL

  echo "export vagrant_dir=#{$vagrant_dir}"     >  /etc/profile.d/vagrant-vars.sh
  echo "export token=#{$token}"                >>  /etc/profile.d/vagrant-vars.sh
  echo "export master_ip=#{$inital_private_ip.to_s}"        >>  /etc/profile.d/vagrant-vars.sh

SHELL


Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"

  config.disksize.size = '5GB'

  config.vm.synced_folder "manifests/", "/home/vagrant/manifests/"

  config.vm.synced_folder "provisions/", "/home/vagrant/provisions/"

  config.vm.provision :dependencies, 
      type: "shell", 
      inline: "/home/vagrant/provisions/commons/index.sh", 
      privileged: true, 
      run: "never"


  config.vm.provision :variables, 
      type: "shell", 
      inline: $set_environment_variables, 
      run: "always"

  config.vm.define "master" do | m |    
    
    m.vm.hostname = "master"
    m.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
    end

    m.disksize.size = '10GB'
    # m.vm.network :public_network , ip: $initial_public_ip.to_s
    m.vm.network :private_network, ip: $inital_private_ip.to_s

    m.vm.network :forwarded_port, guest: 8001, host: 8001
    m.vm.network :forwarded_port, guest: 80, host: 8080, id: "nginx"
    m.vm.provision :start, type: "shell", inline: "/home/vagrant/provisions/master/index.sh", privileged: false, run: "never"
    m.vm.provision :proxy, type: "shell", inline: "/home/vagrant/provisions/master/proxy.sh", privileged: false, run: "never"
    m.vm.provision :"ui-token", type: "shell", inline: "/home/vagrant/provisions/master/show-service-account-dashboard-token.sh", privileged: false, run: "never"

  end

  private_ip = $inital_private_ip
  public_ip  = $initial_public_ip

  workers.times do |n|
  
    private_ip = private_ip.succ
    public_ip = public_ip.succ
    node_name = "worker-#{n}"

    config.vm.define "worker-#{n}" do | m |


      m.vm.hostname = node_name
      m.vm.provider "virtualbox" do |vb|
        vb.memory = 1024
        vb.cpus = 2
      end

      m.vm.network :private_network, ip: private_ip.to_s
      # m.vm.network :public_network , ip: public_ip.to_s

      m.vm.provision "start", 
                      type: "shell", 
                      inline: "/home/vagrant/provisions/worker/index.sh",
                      privileged: false,
                      run: "never" 
    end

  end
end