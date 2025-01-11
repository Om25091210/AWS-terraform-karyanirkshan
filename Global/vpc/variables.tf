
variable "name" {
  type = string
  default = "main"
}

variable "region" {
  type = string
  default = "ap-south-1"
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "tags" {
  type = map(string)
  default = {
    Example    = "name"
    GithubRepo = "terraform-aws-vpc"
    GithubOrg  = "terraform-aws-modules"
  }
  description = "A map of tags to apply to resources."
}