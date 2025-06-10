output "clone-urls" {
  value       = { for i in github_repository.mtc-repo : i.name => [i.http_clone_url, i.ssh_clone_url] }
  description = "repository name and url"
  sensitive   = false
}

# output "varsource" {
#   value       = var.varsource
#   description = "source being used to source variable definition"
# }