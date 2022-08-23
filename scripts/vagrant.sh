#!/bin/bash -e

# add vagrant's public key - user can ssh without password
mkdir -p /home/vagrant/.ssh
chmod 0700 /home/vagrant/.ssh
curl -q -o /home/vagrant/.ssh/authorized_keys https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh
restorecon -R -v /home/vagrant/.ssh

# give sudo access (grants all permissions to user vagrant)
echo "vagrant ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# set password
echo "vagrant" | passwd --stdin vagrant
