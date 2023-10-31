#!/bin/bash
if [ -e "/tmp/pre-$(date +%y-%m-%d)" ]
   then 
	:
else
   echo "#########################df output################################" >> /tmp/pre-$(date +%y-%m-%d)
   df -hPT|grep -E "ext4|vfat|xfs|ext3|nfs|cifs" >> /tmp/pre-$(date +%y-%m-%d)
   df -hPT|grep -E "ext4|vfat|xfs|ext3|nfs|cifs"|wc -l >> /tmp/pre-$(date +%y-%m-%d)
   echo " " >> /tmp/pre-$(date +%y-%m-%d)
   echo "#########################fstab output################################" >> /tmp/pre-$(date +%y-%m-%d)
   cat /etc/fstab >> /tmp/pre-$(date +%y-%m-%d)
   echo " " >> /tmp/pre-$(date +%y-%m-%d)
   echo "#########################uname output################################" >> /tmp/pre-$(date +%y-%m-%d)
   uname -r >> /tmp/pre-$(date +%y-%m-%d)
   echo " " >> /tmp/pre-$(date +%y-%m-%d)
   echo "#########################ipaddr output################################" >> /tmp/pre-$(date +%y-%m-%d)
   ip addr show >> /tmp/pre-$(date +%y-%m-%d)
   echo " " >> /tmp/pre-$(date +%y-%m-%d)
   echo "#########################contab output################################" >> /tmp/pre-$(date +%y-%m-%d)
   crontab -l >> /tmp/pre-$(date +%y-%m-%d) || echo " " /tmp/pre-$(date +%y-%m-%d)
  fi 

