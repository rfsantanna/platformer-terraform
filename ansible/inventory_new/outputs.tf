output "inventory" {
  value     = local.inventory
  sensitive = true
}

output "host_ip_list" {
  value     = flatten(var.hosts.*.ip_address)
}
