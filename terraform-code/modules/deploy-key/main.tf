variable "repo_name" {
  type = string

  validation {
    condition     = length(var.repo_name) > 0
    error_message = "a repo must be specified"
  }
}

resource "tls_private_key" "default" {
  algorithm = "ED25519"
}

resource "github_repository_deploy_key" "default" {
  title      = "${var.repo_name}-key"
  repository = var.repo_name
  key        = tls_private_key.default.public_key_openssh
  read_only  = false
}

resource "local_file" "default" {
  content = tls_private_key.default.private_key_openssh 
  filename = "${github_repository_deploy_key.default.title}.pem"

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ${self.filename}"
  }
}
