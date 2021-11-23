terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

data "github_user" "current" {
  username = ""
}

data "github_repository" "repo" {
  name = var.repository
}

resource "github_repository_file" "pipeline" {
  repository          = data.github_repository.repo.name
  branch              = data.github_repository.repo.default_branch
  file                = "./.github/workflows/platformer_${var.environment}.yml"
  content             = templatefile("${path.module}/actions_terraform.yml", var.pipeline_vars )
  overwrite_on_create = false
}

resource "github_repository_file" "backend" {
  repository          = data.github_repository.repo.name
  branch              = data.github_repository.repo.default_branch
  file                = ".platformer/backends/${var.environment}"
  content             = templatefile("${path.module}/backend.tmpl", var.backend)
  overwrite_on_create = false
}

resource "github_actions_environment_secret" "test_secret" {
  for_each = var.pipeline_vars.secrets
  repository       = data.github_repository.repo.name
  environment      = var.environment
  secret_name      = each.key
  plaintext_value  = each.value
}
