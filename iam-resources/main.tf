module "iam_roles" {
  source = "../modules/iam"

  ecs_task_execution_role_name = "ecsTaskExecutionRole"
  ecs_rds_access_policy_name   = "ecsTaskRDSAccessPolicy"
  aws_region                   = "eu-central-1"

#  rds_resources_arn = [
#    "arn:aws:rds:eu-central-1:123456789012:db:my-rds-instance"
#  ]

  tags = {
    Environment = "Dev"
    Project     = "ECS-Fargate-RDS"
  }
}


