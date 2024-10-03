# terraform-modules/vpc/outputs.tf

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.main.dns_name
}

output "ecs_cluster_id" {
  description = "The ID of the ECS Cluster"
  value       = aws_ecs_cluster.main.id
}

output "ecs_service_id" {
  description = "The ID of the ECS Service"
  value       = aws_ecs_service.main.id
}

output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.main.endpoint
}

output "ecs_security_group_id" {
  description = "The security group ID of the ECS service"
  value       = aws_security_group.ecs_sg.id
}

output "rds_security_group_id" {
  description = "The security group ID of the RDS instance"
  value       = aws_security_group.rds_sg.id
}

