#!/bin/bash
# 
# Clean up EC2 image
# Version 1.1
# Paul Norton <panorton@sdsc.edu>

####################
# Clean out yum
####################

/bin/echo -e "Cleaning out Yum \n"
/usr/bin/yum -q clean all

####################
# Force the logs to rotate
####################

/bin/echo -e "Forcing logs to rotate and cleaning up logs \n"
/usr/sbin/logrotate -f /etc/logrotate.conf 
/bin/rm -f /var/log/*-???????? /var/log/*.gz
find /var/log -type f -exec truncate --size 0 {} \;
truncate --size 0 /root/.bash_history 
truncate --size 0 /home/*/.bash_history

####################
# Clear the audit log & wtmp
####################

/bin/echo -e "Cleaning audit and wmtp logs \n"
/bin/cat /dev/null > /var/log/audit/audit.log
/usr/bin/rm -f /var/log/audit.log.*
/bin/cat /dev/null > /var/log/wtmp

####################
# Clean /tmp out
####################

/bin/echo -e "Cleaning /tmp out \n"
/bin/rm -rf /tmp/* 
/bin/rm -rf /var/tmp/*

####################
# Remove the SSH host keys
####################

/bin/echo -e "Removing SSH host keys for re-generation at reboot \n"
/bin/rm -f /etc/ssh/*key*
