variable "repo_max" {
  type        = number
  description = "number of repos"
  default     = 1

  validation {
    condition     = var.repo_max <= 10
    error_message = "do not deploy more than 10 repos"
  }
}

variable "varsource" {
  type    = string
  default = "variables.tf"
}

variable "env" {
  type        = string
  description = "deployment environment"

  validation {
    condition     = contains(["dev", "prod"], var.env)
    error_message = "Env must be 'dev' or 'prod'"
  }
}

variable "repos" {
  type        = map(map(string))
  description = "repos to create"

  validation {
    condition     = length(var.repos) <= var.repo_max
    error_message = "don't do that"
  }
}