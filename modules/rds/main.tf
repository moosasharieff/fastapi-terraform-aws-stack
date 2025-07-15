

data "aws_ssm_parameter" "db_password" {
  name = "/${var.project}/db/password"
  with_decryption = true
}

resource "aws_db_subnet_group" "db_subnet" {
  name = "${var.project}-db-subnet"
  subnet_ids = var.private_subnet_ids
}

resource "aws_security_group" "rds_sg" {
  name = "${var.project}-rds-sg"
  description = "Allow DB assess from EC2/Bastion Instance"
  vpc_id = var.vpc_id

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups  = [var.ec2_security_group_id]
    description = "Allow DB access from within VPC."
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-rds-sg"
  }

}

resource "aws_db_instance" "postgres" {
  engine = "postgres"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  identifier = "${var.project}-pg"
  db_name = "postgresDB01"
  username = "moosasharieff"
  password = data.aws_ssm_parameter.db_password.value
  db_subnet_group_name = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible = false
  skip_final_snapshot = true
}