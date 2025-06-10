variable "repo_count" {
  type        = number
  description = "number of repos"
  default     = 1

  validation {
    condition     = var.repo_count < 5
    error_message = "do not deploy more than 5 repos"
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
  type        = set(string)
  description = "repos to create"
  default     = ["infra", "backend"]
}