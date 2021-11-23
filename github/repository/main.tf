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

resource "github_repository_environment" "envs" {
  for_each = var.environments
  environment = each.key
  repository  = data.github_repository.repo.name

  reviewers {
    users = each.value.environment.unsecure == "yes" ? [] : [data.github_user.current.id] 
  }
}

module "pipeline" {
  for_each = var.environments
  source   = "git::https://github.com/rfsantanna/platformer-terraform//github/terraform_pipeline"

  environment   = each.key
  pipeline_vars = each.value
  repository    = data.github_repository.repo.name
  backend       = var.files[each.key]

  depends_on = [ github_repository_environment.envs ]
}

