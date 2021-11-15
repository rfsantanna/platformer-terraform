[all]
%{for host in hosts~}
${host.name} ansible_host=${host.ip_address} ansible_ssh_user=${host.admin_username} ansible_ssh_password="${host.admin_password}"
%{endfor~}

[all:vars]
ansible_ssh_common_args="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
%{for var_name, var_value in extra_vars~}
${var_name}="${var_value}"
%{endfor~}
