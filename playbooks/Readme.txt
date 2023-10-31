there are 2 roles in this playbook one for patching (patching-role) and one for user password (user-password) change, I have combined both roles in single main playbook.

For Patching (it is tested on Redhat, CentOS, SUSE and ubuntu)

there is small precheck script in "patching-role/files" directory to take some commands output as precheck in a file and that file will be fetched in pre direcotry at ansible node. 
if you want to execute patching roles then update your servers name in "hostnames" file and execute like below

$ansible-playbook roles_playbook.yaml --inventory=servers -k -K

I haven't included anythging for rebooting server in patching roles, so just reboot the servers by using below ansible ad-hoc caommand after patching.
$ansible hostnames -i hostnames -m shell -a "sudo reboot" -k -K

if you want to change password of Linux servers' user which is present on multiple servers then follow below steps.
1. firstly generate hash password by using below command
$openssl passwd -6
2. Now update this password along with your user name in this file password-role/vars/main.yml
$vi password-role/vars/main.yml
username: "username"
password: "put generated has password here"

Now execute playbook along with password tags, For password change role I have defined password tag with never, which means "password-role"  will be exuected only with password tag.
$ansible-playbook roles_playbook.yaml --inventory=servers -k -K --tags password


