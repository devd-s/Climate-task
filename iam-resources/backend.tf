terraform {
  backend "s3" {
    bucket         = "climatet-terraform-state-bucket"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
    key            = "iam"
  }
}
