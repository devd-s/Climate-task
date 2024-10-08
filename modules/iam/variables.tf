variable "ecs_task_execution_role_name" {
  description = "Name of the ECS Task Execution Role"
  type        = string
}

variable "ecs_rds_access_policy_name" {
  description = "Name of the IAM Policy to allow ECS Task to access RDS"
  type        = string
}

variable "tags" {
  description = "Tags to apply to IAM roles and policies"
  type        = map(string)
  default     = {}
}

# variables.tf
variable "terraform_state_key" {
  description = "Unique key for storing Terraform state in S3"
  type        = string
  default     = "iam"
}

variable "aws_region" {
  description = "The AWS region to deploy the resources"
  type        = string
}