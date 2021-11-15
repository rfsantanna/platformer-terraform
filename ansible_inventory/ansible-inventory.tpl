[all]
%{for host in hosts~}
${host.name} ansible_host=${host.ip_address} ansible_user=${host.admin_username} ansible_password="${host.admin_password}"
%{endfor~}
