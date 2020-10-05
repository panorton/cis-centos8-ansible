#!/bin/bash

sudo rm -f /etc/motd.d/cockpit /etc/issue.d/cockpit.issue
sudo systemctl disable cockpit-motd
sudo systemctl mask cockpit-motd
sudo dnf -q -y upgrade
sudo dnf -q -y install epel-release
sudo dnf -q -y install ansible git nano vim htop bash-completion
cat << EOF >> ~/.ansible.cfg
[defaults]
retry_files_enabled = False
EOF
git config --global user.name "Paul Norton" 
git config --global user.email "panorton@sdsc.edu"
cat << EOF >> ~/.ssh/config
Host github.com
  User panorton@sdsc.edu
  IdentityFile ~/.ssh/panorton-public-testing
EOF
chmod 0600 ~/.ssh/config
git clone git@github.com:panorton/cis-centos8-ansible.git