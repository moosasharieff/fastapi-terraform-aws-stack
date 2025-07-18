

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "generated" {
  key_name = "${var.project}-key"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "aws_ssm_parameter" "private_key" {
  name = "/${var.project}/ec2/private-key"
  type = "SecureString"
  value = tls_private_key.ssh.private_key_pem
}