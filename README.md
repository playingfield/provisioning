# Provisioning

We create an image with Hashicorp Packer and then use it to create a VM with Vagrant.

`make all`

All you need is to download the RHEL 8.5 ISO and put it in /Users/Shared/rhel-8.5-x86_64-dvd.iso or be logged in to the Red Hat Customer Portal and have the ISO downloaded.

## Packer will create a DISA-STIG compliant image

`make image`

## Vagrant will create a VM from the image and mount the DVD as Yum repo.

`make virtualbox`

# Requirements

### macOS computer

These programs can be installed manually, or with `brew bundle`.
### Apps
- Packer
- VirtualBox
- Vagrante

### Ansible
run `source install.rc` in a terminal to create a Python virtualenv.
