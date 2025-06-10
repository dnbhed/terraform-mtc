output "clone-urls" {
  value = { for i in github_repository.mtc-repo : i.name => {
    http-url  = i.http_clone_url,
    ssh-url   = i.ssh_clone_url,
    # pages-url = i.pages[0].html_url
  } }
  description = "repository name and url"
  sensitive   = false
}

# output "varsource" {
#   value       = var.varsource
#   description = "source being used to source variable definition"
# }