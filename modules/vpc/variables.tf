# terraform-modules/vpc/variables.tf

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  description = "List of CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "azs" {
  description = "List of availability zones to use in the region"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "execution_role_arn" {
  description = "ARN of the ECS execution role"
  type        = string
  default     = ""  # Replace with actual ARN or provide as input
}

variable "task_role_arn" {
  description = "ARN of the task role"
  type        = string
  default     = ""  # Replace with actual ARN or provide as input
}


variable "container_image" {
  description = "Container image to deploy in Fargate"
  type        = string
  default     = "nginx:latest"
}


variable "db_name" {
  description = "Name of the RDS database"
  type        = string
  default     = "climate"
}

variable "db_username" {
  description = "Username for the RDS database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Password for the RDS database"
  type        = string
  sensitive   = true
}
