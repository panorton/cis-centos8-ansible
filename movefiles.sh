#!/bin/bash

mkdir /mnt/root 
mkdir /mnt/tmp 
mkdir /mnt/var 
mkdir /mnt/home
mount -o nouuid /dev/nvme1n1p2 /mnt/root/
dnf -q -y install lvm2 
vgchange -a y vg 

mount /dev/mapper/vg-lv_tmp /mnt/tmp/ 
mount /dev/mapper/vg-lv_var /mnt/var/ 
mkdir /mnt/var/log/ 
mount /dev/mapper/vg-lv_var_log /mnt/var/log/ 
mkdir /mnt/var/log/audit 
mount /dev/mapper/vg-lv_var_log_audit /mnt/var/log/audit/ 
mount /dev/mapper/vg-lv_home /mnt/home/ 

mv /mnt/root/tmp/{.[!.],}* /mnt/tmp/
mv /mnt/root/var/tmp/{.[!.],}* /mnt/tmp/
mv /mnt/root/var/log/audit/* /mnt/var/log/audit/
rm -rf /mnt/root/var/log/audit/
mv /mnt/root/var/log/* /mnt/var/log/ 
rm -rf /mnt/root/var/log/
mv /mnt/root/var/* /mnt/var/ 
mv /mnt/root/home/* /mnt/home/ 

cat << EOF >> /mnt/root/etc/fstab
/dev/vg/lv_home /home   xfs     defaults,nodev        0 0
/dev/vg/lv_tmp  /tmp    xfs     rw,nodev,noexec,nosuid        0 0
/dev/vg/lv_var  /var    xfs     defaults,nodev        0 0
/dev/vg/lv_var_log      /var/log        xfs     defaults,nodev        0 0
/dev/vg/lv_var_log_audit        /var/log/audit  xfs     defaults,nodev        0 0
none   /dev/shm        tmpfs   defaults,nodev,nosuid,noexec    0 0
/dev/vg/lv_tmp   /var/tmp       xfs    defaults,nosuid,nodev,noexec    0 0
EOF
