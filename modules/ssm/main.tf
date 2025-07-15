

resource "random_password" "db_password" {
  length  = 16
  special = true
  override_special = "!#$%^&*()-_=+[]{}<>?"
}


resource "aws_ssm_parameter" "db_password" {
  name = "/${var.project}/db/password"
  type = "SecureString"
  value = random_password.db_password.result

  tags = {
    Name = "${var.project}-db-password"
  }

}