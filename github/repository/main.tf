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

resource "github_repository_file" "files" {
  for_each = var.files

  repository          = data.github_repository.repo.name
  branch              = data.github_repository.repo.default_branch
  file                = each.key
  content             = each.value
  overwrite_on_create = false
}

resource "github_repository_environment" "envs" {
  for_each = var.environments
  environment = each.key
  repository  = data.github_repository.repo.name

  reviewers {
    users = [data.github_user.current.id]
  }
}

module "pipeline" {
  for_each = var.environments
  source   = "${path.module}/../terraform_pipeline"

  environment   = each.key
  pipeline_vars = each.value
  repository    = data.github_repository.name

  depends_on = [ github_repository_environment.envs ]
}
