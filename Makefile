ANSIBLE_DEBUG=1
lint:
	vagrant validate
	packer validate rhel8.pkr.hcl
	ansible-inventory --graph
	ansible-galaxy install -p roles -f -r roles/requirements.yml
	ansible-galaxy collection install -r collections/requirements.yml
	ansible-playbook --syntax-check vagrant-playbook.yml
	ansible-lint vagrant-playbook.yml

clean: lint
	@vagrant destroy -f
	@ssh-keygen -R 192.168.56.11
	@ssh-keygen -R 192.168.56.12
	@ssh-keygen -R 192.168.56.13
	@vagrant box remove rhel/efi || /usr/bin/true
	@rm -rf output-rhel8 .vagrant

output-rhel8/rhel8.box:
	packer build rhel8.pkr.hcl

box: output-rhel8/rhel8.box
	vagrant box add --force --name rhel/efi output-rhel8/rhel8.box

image: output-rhel8/rhel8.box

all: clean box
	vagrant up
