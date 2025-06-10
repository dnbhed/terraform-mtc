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
  depends_on = [github_repository_file.readme, github_repository_file.main]
  provisioner "local-exec" {
    command = "gh repo clone ${github_repository.mtc-repo[each.key].name}"
  }
}

resource "github_repository_file" "readme" {
  for_each            = var.repos
  repository          = github_repository.mtc-repo[each.key].name
  branch              = "main"
  file                = "README.md"
  content = templatefile("templates/readme.tftpl", {
    env = var.env,
    lang = each.value.lang,
    repo = each.key,
    authorname = data.github_user.current.name
  })
  # content             = <<-EOT
  #                       # This is a ${var.env} ${each.value.lang} repository is for ${each.key} devs. 
  #                       The infra was last modified by: ${data.github_user.current.name}
  #                       EOT
  overwrite_on_create = true
  # lifecycle {
  #   ignore_changes = [
  #     content,
  #   ]
  # }
}

resource "github_repository_file" "main" {
  for_each            = var.repos
  repository          = github_repository.mtc-repo[each.key].name
  branch              = "main"
  file                = each.value.filename
  content             = "Hello ${each.value.lang}!"
  overwrite_on_create = true
  lifecycle {
    ignore_changes = [
      content,
    ]
  }
}

# moved {
#     from = <old address for the resource>
#     to = <new address for the resource>
# }
