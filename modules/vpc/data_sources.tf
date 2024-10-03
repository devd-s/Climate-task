# terraform-modules/vpc/data_sources.tf

# Retrieve the database username from SSM Parameter Store
data "aws_ssm_parameter" "db_username" {
  name            = "/myapp/rds/username"
  with_decryption = false
}

# Retrieve the database password from SSM Parameter Store
data "aws_ssm_parameter" "db_password" {
  name            = "/myapp/rds/password"
  with_decryption = true
}
