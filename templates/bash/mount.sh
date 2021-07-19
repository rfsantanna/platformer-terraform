#!/bin/bash 


mkdir ${mount_path}
if [ ! -d "/etc/smbcredentials" ]; then
 mkdir /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/${mount_user}.cred" ]; then
    echo 'username=${mount_user}' > /etc/smbcredentials/${mount_user}.cred
    echo 'password=${mount_pass}' >> /etc/smbcredentials/${mount_user}.cred
fi
chmod 600 /etc/smbcredentials/${mount_user}.cred

echo "${mount_share} ${mount_path} cifs nofail,vers=3.0,credentials=/etc/smbcredentials/${mount_user}.cred,dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab
mount -t cifs ${mount_share} ${mount_path} -o vers=3.0,credentials=/etc/smbcredentials/${mount_user}.cred,dir_mode=0777,file_mode=0777,serverino

