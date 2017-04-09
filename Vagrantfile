# -*- mode: ruby -*-
# vi: set ft=ruby :
#file_to_disk = './tmp/large_disk.vdi' (Additional Disk)

hosts = {
  "visor.saschakaupp.com" => "192.168.33.10",
  "srv.saschakaupp.com" => "192.168.33.11",
  "monitor.tvollmer.de" => "192.168.33.12"
}

Vagrant.configure(2) do |config|
  # config.vm.box = "debian/jessie64" #<- Upstream
  config.vm.box = "kaorimatz/debian-8.6-amd64"
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  # Configuration deployment
  config.vm.provision "preinstall", type: "shell", inline: "/vagrant/vagrant_preinstall.sh"
  config.vm.provision "ansible" do |ansible|
    ansible.groups = {
      "hypervisor" => ["visor.saschakaupp.com"],
      "guest" => ["srv.saschakaupp.com"],
      "mailserver" => ["srv.saschakaupp.com"],
      "monitoring" => ["monitor.tvollmer.de"],
      "datacenter" => ["visor.saschakaupp.com","srv.saschakaupp.com","monitor.tvollmer.de"],
    }
    ansible.playbook = "all.yml"
    ansible.raw_arguments = [
      "-b",
      "--become-user=root"
    ]
  end

  hosts.each do |name, ip|
    config.vm.define name do |machine|
      machine.vm.hostname = "%s" % name
      machine.vm.network :private_network, ip: ip
    end
  end
end
