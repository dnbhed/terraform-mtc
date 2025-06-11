module "repos" {
  source   = "./modules/dev-repos"
  repo_max = 10
  env      = "dev"
  repos = {
    infra = {
      lang     = "terraform",
      filename = "main.tf"
      pages    = true
    },
    backend = {
      lang     = "go",
      filename = "main.go"
      pages    = false
    }
  }
}