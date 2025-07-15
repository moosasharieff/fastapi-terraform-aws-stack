

output "vpc_id" {
  value = aws_vpc.main.id
  description = "The ID of the main VPC."
}

output "public_subnet_id" {
  value = aws_subnet.public.id
  description = "The ID of public subnet within the VPC."
}

output "private_subnet_ids" {
  value = [aws_subnet.private_a.id, aws_subnet.private_b.id]
  description = "The ID of private subnet within the VPC."
}