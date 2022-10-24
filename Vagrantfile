# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end
  config.vm.provider "virtualbox"
  config.vm.box = "rhel/efi"
  config.vm.box_check_update = false
  config.ssh.insert_key = false
  config.ssh.verify_host_key = false
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = false
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
  N = 3
  (1..N).each do |server_id|
    config.vm.define "192.168.56.1#{server_id}" do |server|
      server.vm.hostname = "192.168.56.1#{server_id}.nip.io"
      server.vm.network "private_network", ip: "192.168.56.1#{server_id}"
      server.vm.synced_folder "/Users/Shared", "/vagrant", id: "vagrant-root", disabled: false
      server.vm.provider "virtualbox" do |virtualbox|
        virtualbox.name = "192.168.56.1#{server_id}.nip.io"
        virtualbox.gui = false
        # Boot order setting is ignored if EFI is enabled
        # https://www.virtualbox.org/ticket/19364
        virtualbox.customize ["modifyvm", :id,
          "--audio", "none",
          "--boot1", "disk",
          "--boot2", "net",
          "--boot3", "none",
          "--boot4", "none",
          "--cpus", 2,
          "--firmware", "EFI",
          "--memory", 8192,
          "--usb", "on",
          "--usbehci", "on",
          "--vrde", "on",
          "--graphicscontroller", "VMSVGA",
          "--vram", "64"
        ]
        virtualbox.customize ["storageattach", :id,
          "--device", "0",
          "--medium", "emptydrive",
          "--port", "1",
          "--storagectl", "IDE Controller",
          "--type", "dvddrive"
        ]
      end
          # Only execute once the Ansible provisioner,
      # when all the servers are up and ready
      if server_id == N
        server.vm.provision :ansible do |ansible|
          ansible.compatibility_mode = "2.0"
          ansible.galaxy_roles_path = "roles"
          ansible.inventory_path = "inventory"
          # Disable default limit to connect to all the servers
          ansible.limit = "all"
          ansible.playbook = "vagrant-playbook.yml"
          ansible.galaxy_role_file = "roles/requirements.yml"
          ansible.galaxy_roles_path = "roles"
          ansible.verbose = ""
          ansible.groups = {
            "database" => ["server01"],
            "automationhub" => ["server02"],
            "tower" => ["server01"]
          }
        end
      end
    end
  end
end
