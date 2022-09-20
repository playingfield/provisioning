variable "iso_url1" {
  type    = string
  default = "file:///Users/Shared/rhel-8.5-x86_64-dvd.iso"
}

variable "iso_url2" {
  type    = string
  default = "https://developers.redhat.com/content-gateway/file/rhel-8.5-x86_64-dvd.iso"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:1f78e705cd1d8897a05afa060f77d81ed81ac141c2465d4763c0382aa96cadd0"
}

source "virtualbox-iso" "rhel8" {
  boot_command   = [
  "<wait>c<wait>",
  "linuxefi /images/pxeboot/vmlinuz inst.stage2=hd:LABEL=RHEL-8-5-0-BaseOS-x86_64 inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg quiet<enter>",
  "initrdefi /images/pxeboot/initrd.img<enter>",
  "boot<enter>"
]
  boot_wait              = "5s"
  cpus                   = 2
  disk_size              = 65536
  firmware               = "efi"
  gfx_controller         = "vmsvga"
  gfx_efi_resolution     = "1920x1080"
  gfx_vram_size          = "128"
  guest_os_type          = "RedHat_64"
  guest_additions_mode   = "upload"
  guest_additions_path   = "/home/vagrant/VBoxGuestAdditions.iso"
  hard_drive_interface   = "sata"
  hard_drive_nonrotational = true
  headless               = true
  http_directory         = "kickstart"
  iso_checksum           = "${var.iso_checksum}"
  iso_interface          = "ide"
  iso_urls               = ["${var.iso_url1}", "${var.iso_url2}"]
  memory                 = 4096
  nested_virt            = true
  shutdown_command       = "echo 'vagrant' | sudo -S /sbin/halt -h -p"
  ssh_password           = "vagrant"
  ssh_username           = "vagrant"
  ssh_wait_timeout       = "10000s"
  rtc_time_base          = "UTC"
  usb                    = true
  vboxmanage = [
    [ "modifyvm", "{{.Name}}", "--firmware", "EFI" ],
    [ "modifyvm", "{{.Name}}", "--usbehci", "true" ],
  ]
  virtualbox_version_file= ".vbox_version"
  vrdp_bind_address      = "0.0.0.0"
  vrdp_port_min          = "5900"
  vrdp_port_max          = "5900"
  vm_name                = "rhel8-vm"
}

build {
  sources = ["source.virtualbox-iso.rhel8"]

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    scripts         = ["scripts/vagrant.sh", "scripts/vmtools.sh", "scripts/cleanup.sh"]
  }
  provisioner "ansible" {
    playbook_file = "./packer-playbook.yml"
  }
  post-processors {
    post-processor "vagrant" {
      keep_input_artifact  = true
      compression_level    = 9
      output               = "output-rhel8/rhel8.box"
      vagrantfile_template = "Vagrantfile.template"
    }
  }
}
