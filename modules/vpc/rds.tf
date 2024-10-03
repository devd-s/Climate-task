# terraform-modules/vpc/rds.tf

# Create RDS Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

# Create RDS PostgreSQL Instance
resource "aws_db_instance" "main" {
  allocated_storage    = 20
  engine               = "postgres"             # Change this to "mysql" or other DB engines if needed
  engine_version       = "13.16"
  instance_class       = "db.t3.micro"          # Change instance class based on requirements
  identifier            = var.db_name
  username             = data.aws_ssm_parameter.db_username.value 
  password             = data.aws_ssm_parameter.db_password.value
  parameter_group_name = "default.postgres13"
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot  = true
  multi_az             = false
  publicly_accessible  = false        

  tags = {
    Name = "${var.environment}-rds"
    Environment = var.environment
  }
}
