ANSIBLE_DEBUG=1
lint:
	vagrant validate
	packer validate rhel8.pkr.hcl
	ansible-inventory --graph
	ansible-galaxy install -p roles -f -r roles/requirements.yml
	ansible-lint vagrant-playbook.yml

clean: lint
	@vagrant destroy -f
	@vagrant box remove rhel/8 || /usr/bin/true
	@rm -rf output-rhel8 .vagrant

output-rhel8/rhel8.box:
	packer build rhel8.pkr.hcl

virtualbox: output-rhel8/rhel8.box
	vagrant box add --force --name rhel/8 output-rhel8/rhel8.box
	vagrant up rhel8-vm

image: output-rhel8/rhel8.box

all: clean virtualbox
