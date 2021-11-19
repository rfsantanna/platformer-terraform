terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

locals {
  workflow_file = {
    "./.github/workflows/platformer.yml" = templatefile(
      "${path.module}/actions_terraform.yml", var.workflow_vars
    )
  }
  repo_files = merge(local.workflow_file, var.files)
}

data "github_user" "current" {
  username = "" 
}

data "github_repository" "repo" {
  name = var.exists ? var.name : github_repository.repo.0.name
}

resource "github_repository" "repo" {
  count = var.exists ? 0 : 1

  name               = var.name
  description        = var.description
  visibility         = var.visibility
  auto_init          = true
  archived           = var.archived
  archive_on_destroy = false
}

resource "github_repository_file" "files" {
  for_each = local.repo_files

  repository          = data.github_repository.repo.name
  branch              = data.github_repository.repo.default_branch
  file                = each.key
  content             = each.value
  overwrite_on_create = false
}

resource "github_repository_environment" "platformer" {
  environment = "platformer"
  repository  = data.github_repository.repo.name

  reviewers {
    users = [data.github_user.current.id]
  }
}

resource "github_actions_environment_secret" "platformer" {
  for_each = var.action_secrets

  repository      = data.github_repository.repo.name
  environment     = github_repository_environment.platformer.environment
  secret_name     = each.key
  plaintext_value = each.value
}
