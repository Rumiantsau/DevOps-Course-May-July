variable "access_key_id" {
}

variable "secret_access_key" {
}

variable "ssh_key" {
}

variable "region" {
  default  = "us-east-1"
}

variable "vpc_network" {
  default = "172.16.0.0/16"
}

variable "public_subnets" {
  default = ["172.16.0.0/24", "172.16.1.0/24"]
}

variable "private_subnets" {
  default = ["172.16.2.0/24", "172.16.3.0/24"]
}

locals {
  project_name = "devops-exam"
  tags = {
     "project" = "devops-exam"
     "client" = "Anderser"    
     "owner" = "mikalairumiantsau@gmail.com"
  }
}