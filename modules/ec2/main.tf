

resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id
  description = "Allow SSH"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "bastion" {

  ami = "ami-01f23391a59163da9"
  instance_type = "t2.micro"
  subnet_id = var.public_subnet_id
  key_name = var.private_key_pem
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.project}-bastion"
  }

}