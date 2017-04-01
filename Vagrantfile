# -*- mode: ruby -*-
# vi: set ft=ruby :
#file_to_disk = './tmp/large_disk.vdi' (Additional Disk)

hosts = {
  "visor" => "192.168.33.10",
  "srv" => "192.168.33.11"
}

Vagrant.configure(2) do |config|
  #config.vm.box = "debian/jessie64" <- Upstream
  config.vm.box = "kaorimatz/debian-8.6-amd64"
  config.vbguest.auto_update = false

  # Configuration deployment
  config.vm.provision "preinstall", type: "shell", inline: "/vagrant/vagrant_preinstall.sh"
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

  hosts.each do |name, ip|
    config.vm.define name do |machine|
      machine.vm.hostname = "%s.foto23.com" % name
      machine.vm.network :private_network, ip: ip
    end
  end
end
