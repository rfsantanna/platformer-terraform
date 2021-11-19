terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
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
  for_each = var.terraform_files

  repository          = data.github_repository.repo.name
  branch              = "main"
  file                = each.key
  content             = each.value
  overwrite_on_create = false
}

resource "github_repository_environment" "platformer" {
  environment = "platformer"
  repository  = data.github_repository.repo.name
}

resource "github_actions_environment_secret" "platformer" {
  for_each = var.action_secrets

  repository      = data.github_repository.repo.name
  environment     = github_repository_environment.platformer.environment
  secret_name     = each.key
  plaintext_value = each.value
}