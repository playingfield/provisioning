# Provisioning

[Wiki Page](https://github.com/playingfield/provisioning/wiki)

## What is this?

We create an image with Hashicorp Packer and then use it to create VMs with Vagrant. The VMs run Ansible Automation Platform,

`make all`

You need to download the RHEL 8.5 ISO and put it in /Users/Shared/rhel-8.5-x86_64-dvd.iso or be logged in to the Red Hat Customer Portal and have the ISO downloaded.
You also need to download the bundle installer for AAP and the ansible.controller collection from Red Hat.

## Packer will create a DISA-STIG compliant image.

`make image`

## Vagrant will create a VM from the image and mount the DVD as Yum repo.

`make virtualbox`

# Requirements

### macOS computer

These programs can be installed manually.

### Apps
- Packer
- VirtualBox
- Vagrant

### Ansible

run `source install.rc` in a terminal to create a Python virtualenv.
