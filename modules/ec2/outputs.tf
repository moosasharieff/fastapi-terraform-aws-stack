output "ec2_security_group_id" {
  value = aws_security_group.ec2_sg.id
  description = "The Security Group ID of EC2 Instances"
}

output "ec2_public_ip" {
  value = aws_instance.bastion.public_ip
  description = "Public IP of the bastion host."
}