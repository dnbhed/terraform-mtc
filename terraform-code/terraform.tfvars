repo_max = 10
env      = "dev"
repos = {
  infra = {
    lang     = "terraform",
    filename = "main.tf"
  },
  backend = {
    lang     = "go",
    filename = "main.go"
  }
}