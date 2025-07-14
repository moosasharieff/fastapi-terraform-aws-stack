
variable "vpc_id" {
  description = "VPC ID where EC2 and SGs will be created"
  type = string
}

variable "project" {
  description = "Project name variable from root."
  type = string
}

variable "public_subnet_id" {
  description = "Public Subnet ID variable created in VPC"
  type = string
}

variable "private_key_pem" {
  description = "Private .pem file as Key Name to SSH into resources"
  type = string
}