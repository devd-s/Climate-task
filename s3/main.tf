provider "aws" {
  region = "eu-central-1"
}

module "s3_backend" {
  source = "../modules/s3"

  bucket_name = "climatet-terraform-state-bucket"
  tags        = {
    Environment = "Dev"
    Project     = "ECS-Fargate-RDS"
  }
}



