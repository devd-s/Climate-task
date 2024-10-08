# root main.tf

provider "aws" {
  region = "eu-central-1"
}



data "aws_ssm_parameter" "db_username" {
  name            = "/myapp/rds/username"
  with_decryption = false
}

# Retrieve the database password from SSM Parameter Store
data "aws_ssm_parameter" "db_password" {
  name            = "/myapp/rds/password"
  with_decryption = true
}


module "vpc" {
  source = "../modules/vpc"

  environment     = "dev"
  vpc_cidr        = "10.0.0.0/16"
#  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] # For high availability this should be created in 3 different zones, keeping it commented for now.
#  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"] # For high availability this should be created in 3 different zones, keeping it commented for now.
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.4.0/24","10.0.5.0/24"]
#  azs             = ["eu-central-1a", "eu-central-1b", "eu-central-1c"] # For high availability this should be created in 3 different zones, keeping it commented for now.
  azs             = ["eu-central-1a", "eu-central-1b"]
  execution_role_arn = "arn:aws:iam::198464718186:role/ecsTaskExecutionRole" 
  container_image    = "198464718186.dkr.ecr.eu-central-1.amazonaws.com/sample-app-task"
  
#  db_name           = "climate" # This can be changed based on the need
  db_username = data.aws_ssm_parameter.db_username.value
  db_password = data.aws_ssm_parameter.db_password.value

}

