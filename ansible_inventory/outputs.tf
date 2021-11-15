output "inventory" {
  value     = yamlencode(local.inventory_map)
  sensitive = true
}
