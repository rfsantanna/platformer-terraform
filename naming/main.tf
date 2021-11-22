locals {
  platforms = {
    for file in var.files
    : trimsuffix(basename(file), ".yml") => yamldecode(file(file))
  }
  github_repos = {
    for platform, config in local.platforms
    : platform => config
    if contains(keys(config), "github")
  }
  azure_credentials = {
    for platform, config in local.platforms
    : platform => config
    if contains(keys(config.credentials), "azure_service_principal")
  }
}
