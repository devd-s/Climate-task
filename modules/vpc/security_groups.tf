# terraform-modules/vpc/security_groups.tf

# Define ECS security group
resource "aws_security_group" "ecs_sg" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-ecs-sg"
    Environment = var.environment
  }
}

# Define RDS security group
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-rds-sg"
    Environment = var.environment
  }
}

# Allow ECS to communicate with RDS (Inbound Rule in RDS SG)
resource "aws_security_group_rule" "allow_ecs_to_rds" {
  type                     = "ingress"
  from_port                = 5432                      # Port for PostgreSQL
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.ecs_sg.id
  description              = "Allow ECS to access RDS"
}

# Allow RDS to respond to ECS (Outbound Rule in RDS SG)
resource "aws_security_group_rule" "allow_rds_to_ecs" {
  type                     = "egress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs_sg.id
  source_security_group_id = aws_security_group.rds_sg.id
  description              = "Allow RDS to respond to ECS"
}

# Allow inbound traffic from ALB's security group to ECS SG on port 5000
resource "aws_security_group_rule" "allow_alb_to_ecs" {
  type                     = "ingress"
  from_port                = 80                # Match the target group port
  to_port                  = 80                # Match the target group port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs_sg.id
  source_security_group_id = aws_security_group.alb_sg.id  # Allow only traffic from ALB's security group
  description              = "Allow inbound traffic from ALB to ECS on port 5000"
}

