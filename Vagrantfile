# -*- mode: ruby -*-
# vi: set ft=ruby :
#file_to_disk = './tmp/large_disk.vdi' (Additional Disk)

Vagrant.configure(2) do |config|
  #config.vm.box = "debian/jessie64" <- Upstream
  config.vm.box = "kaorimatz/debian-8.6-amd64"
  config.vbguest.auto_update = false

  # Configuration deployment
  config.vm.provision "preinstall", type: "shell", inline: "sudo apt-get update; sudo apt-get -y install facter python"
  config.vm.provision "ansible" do |ansible|
    ansible.groups = {
      "hypervisor" => ["visor"],
      "guest" => ["srv"],
      "mailserver" => ["srv"],
      "monitoring" => ["monitor"],
      "datacenter" => ["visor","srv","monitor"],
    }
    ansible.playbook = "all.yml"
    ansible.raw_arguments = [
      "-b",
      "--become-user=root"
    ]
  end
  config.vm.define 'visor' do |visor|
    visor.vm.hostname = "visor.foto23.com"
    visor.vm.network "private_network", ip: "192.168.33.10"
  end
  config.vm.define 'srv' do |srv|
    srv.vm.hostname = "srv.foto23.com"
    srv.vm.network "private_network", ip: "192.168.33.11"
  end
end
