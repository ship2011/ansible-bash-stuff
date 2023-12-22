#!/bin/bash
df -hPT|grep -E "ext4|xfs|ext3|nfs|cifs"|wc -l
echo "==============fstab output======================="
cat /etc/fstab 


