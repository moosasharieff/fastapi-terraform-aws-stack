variable "project" {
  type = string
  description = "Project variables coming from root."
}

variable "private_subnet_ids" {
  type = list(string)
  description = "Private subnets from VPC Modules."
}

variable "vpc_id" {
  type = string
  description = "VPC ID"
}

variable "ec2_security_group_id" {
  type = string
  description = "EC2 Security Group ID"
}