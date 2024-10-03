# AWS ECS Fargate Deployment with RDS Integration and Secure Secrets Management

This project uses Terraform to deploy a Flask application on AWS ECS Fargate, along with an RDS PostgreSQL database and secure secrets management using AWS Secrets Manager and SSM Parameter Store. The infrastructure includes an Application Load Balancer (ALB) to handle incoming traffic and integrates CloudWatch logging for monitoring and troubleshooting.

## Project Structure

- **`main.tf`**: Primary Terraform configuration file to define AWS infrastructure.
- **`alb.tf`**: Configuration for Application Load Balancer and listener rules.
- **`ecs_fargate.tf`**: Defines ECS Fargate service, task definition, and associated IAM policies.
- **`rds.tf`**: Provisions the RDS PostgreSQL database instance.
- **`security_groups.tf`**: Defines security groups for ECS, RDS, and ALB.
- **`data_sources.tf`** & **`data.tf`**: Provides necessary AWS data sources such as account ID, region, and VPC.
- **`variables.tf`**: Defines input variables to customize the infrastructure.
- **`versions.tf`**: Specifies Terraform and AWS provider version constraints.
- **`outputs.tf`**: Outputs the relevant infrastructure details after deployment (e.g., ALB DNS name, VPC ID).

## Prerequisites

- AWS CLI configured with appropriate IAM permissions
- Terraform >= 0.12
- Pre-created secrets in AWS Secrets Manager and SSM Parameter Store

## Deployment Steps

### Step 1: Clone the Repository
Clone the repository to your local environment and navigate to the directory:

```bash
git clone <repository-url>
cd <repository-directory>

## To create secrets

aws ssm put-parameter --name "/myapp/rds/username" --value "admin" --type "String"
aws ssm put-parameter --name "/myapp/rds/password" --value "password" --type "SecureString"
aws secretsmanager create-secret --name /myapp/dev/DB_HOST --secret-string "mydb-host-url"

