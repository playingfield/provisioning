# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  config.ssh.insert_key = false
  config.ssh.verify_host_key = false
  config.vm.box_check_update = false


  config.vm.provision :ansible do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible_inventory = "inventories/vagrant.ini"
    ansible.galaxy_role_file = "roles/requirements.yml"
    ansible.galaxy_roles_path = "roles"
    ansible.playbook = "vagrant-playbook.yml"
    ansible.verbose = "v"
    ansible.groups = {
      "podman" => ["rhel8-disa-stig"],
    }
  end

  config.vm.define 'rhel8-disa-stig', autostart: true, primary: true do |rhel8|
    rhel8.vm.box = 'rhel8-disa-stig'
    rhel8.vm.hostname = 'rhel8-disa-stig'
    rhel8.vm.synced_folder ".", disabled: true
    rhel8.vm.provider :virtualbox do |virtualbox|
      virtualbox.name = 'rhel8-disa-stig'
      virtualbox.gui = false
      virtualbox.customize ["modifyvm", :id,
        "--boot1", "disk",
        "--boot2", "net",
        "--boot3", "none",
        "--boot4", "none",
        "--audio", "none",
        "--cpus", 2,
        "--memory", 4096,
        "--vrde", "on",
        "--graphicscontroller", "VMSVGA",
        "--vram", "128"
      ]
      virtualbox.customize ["storageattach", :id,
        "--device", "0",
        "--medium", "/Users/Shared/rhel-8.5-x86_64-dvd.iso",
        "--port", "1",
        "--storagectl", "SATA Controller",
        "--type", "dvddrive"
      ]
    end
  end
end
