output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_rds_access_policy_arn" {
  description = "ARN of the policy allowing ECS task to access RDS"
  value       = aws_iam_policy.ecs_rds_access_policy.arn
}
