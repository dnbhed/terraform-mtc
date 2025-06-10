# resource "random_id" "random" {
#   byte_length = 2
#   count       = var.repo_count
# }

resource "github_repository" "mtc-repo" {
  for_each    = var.repos
  name        = "mtc-repo-${each.key}"
  description = "${each.value.lang} Code for MTC"
  visibility  = var.env == "dev" ? "public" : "private"
  auto_init   = true
  provisioner "local-exec" {
    command = "gh repo view ${self.name} --web"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf ./${self.name}"
  }
}

resource "terraform_data" "repo-clone" {
  for_each   = var.repos
  depends_on = [github_repository_file.readme, github_repository_file.index]
  provisioner "local-exec" {
    command = "gh repo clone ${github_repository.mtc-repo[each.key].name}"
  }
}

resource "github_repository_file" "readme" {
  for_each            = var.repos
  repository          = github_repository.mtc-repo[each.key].name
  branch              = "main"
  file                = "README.md"
  content             = "# This is a ${var.env} ${each.value.lang} repository is for ${each.key} devs"
  overwrite_on_create = true
}

resource "github_repository_file" "index" {
  for_each            = var.repos
  repository          = github_repository.mtc-repo[each.key].name
  branch              = "main"
  file                = each.value.filename
  content             = "Hello ${each.value.lang}!"
  overwrite_on_create = true
}

# output "clone-urls" {
#   value       = { for i in github_repository.mtc-repo[*] : i.name => i.http_clone_url }
#   description = "repository name and url"
#   sensitive   = false
# }

# output "varsource" {
#   value       = var.varsource
#   description = "source being used to source variable definition"
# }