#!/bin/bash -x

rm -rf /dev/.udev/
if [ -f /etc/sysconfig/network-scripts/ifcfg-eth0 ] ; then
    sed -i "/^HWADDR/d" /etc/sysconfig/network-scripts/ifcfg-eth0
    sed -i "/^UUID/d" /etc/sysconfig/network-scripts/ifcfg-eth0
fi

# update packages
#yum update -y
yum clean all

# minimize disk usage
find /var/log/ -name "./*.log" -exec rm -f {} \;
rm -f /var/log/anaconda.syslog
rm -f /var/log/dmesg.old
truncate -s0 /var/log/lastlog
truncate -s0 /var/log/wtmp
truncate -s0 /var/log/messages
truncate -s0 /var/log/lastlog


rm -rf /tmp/vola /tmp/*.gz /tmp/packer-provisioner-ansible-local

case "$PACKER_BUILDER_TYPE" in

  virtualbox-iso)
      # shellcheck disable=SC2155
      readonly swapuuid=$(/sbin/blkid -o value -l -s UUID -t TYPE=swap)
      # shellcheck disable=SC2155
      readonly swappart=$(readlink -f /dev/disk/by-uuid/"$swapuuid")
      /sbin/swapoff "$swappart"
      dd if=/dev/zero of="$swappart" bs=1M || echo "dd exit code $? is suppressed"
      /sbin/mkswap -U "$swapuuid" "$swappart"
      history -c
      # Zero out the rest of the free space using dd, then delete the written file.
      dd if=/dev/zero of=/EMPTY bs=1M
      rm -f /EMPTY

      # WORKAROUND: remove myself: https://github.com/mitchellh/packer/issues/1536
      rm -f /tmp/script.sh

      # Add `sync` so Packer doesn't quit too early, before the large file is deleted.
      sync
      ;;
  *)
      echo "Done for ${PACKER_BUILDER_TYPE}"
      ;;

esac
