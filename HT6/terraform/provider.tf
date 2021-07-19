provider "aws" {
  # version    = "~> 2.70"
  region     = var.region
  access_key = var.access_key_id
  secret_key = var.secret_access_key
  # assume_role {
  #   role_arn = var.assume_role
  #   session_name = var.session_name
  # }
}