#!/bin/bash 


mkdir ${path}
if [ ! -d "/etc/smbcredentials" ]; then
 mkdir /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/${user}.cred" ]; then
    echo 'username=${user}' > /etc/smbcredentials/${user}.cred
    echo 'password=${pass}' >> /etc/smbcredentials/${user}.cred
fi
chmod 600 /etc/smbcredentials/${user}.cred

echo "${share} ${path} cifs nofail,vers=3.0,credentials=/etc/smbcredentials/${user}.cred,dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab
mount -t cifs ${share} ${path} -o vers=3.0,credentials=/etc/smbcredentials/${user}.cred,dir_mode=0777,file_mode=0777,serverino

