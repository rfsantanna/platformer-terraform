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
  file                = each.key
  content             = each.value
  overwrite_on_create = false
}

resource "github_actions_environment_secret" "test_secret" {
  for_each = var.pipeline_vars
  repository       = data.github_repository.repo.name
  environment      = var.environment
  secret_name      = each.key
  plaintext_value  = each.value
}
