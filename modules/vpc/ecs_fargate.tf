# terraform-modules/vpc/ecs_fargate.tf

# Create ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-ecs-cluster"

  tags = {
    Name = "${var.environment}-ecs-cluster"
    Environment = var.environment
  }
}

resource "aws_ecs_task_definition" "fargate" {
  family                   = "${var.environment}-task"
  cpu                      = "2048"
  memory                   = "4096"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn 

  container_definitions = jsonencode([
    {
      name  = "${var.environment}-container"
      image = var.container_image
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.environment}-task"
          awslogs-region        = local.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      secrets = [
        {
          name      = "DB_PASSWORD"
          valueFrom = "arn:aws:ssm:${local.aws_region}:${local.aws_account_id}:parameter/myapp/rds/password"
        },
        {
          name      = "DB_USER"
          valueFrom = "arn:aws:ssm:${local.aws_region}:${local.aws_account_id}:parameter/myapp/rds/username"
        },
      ]
      environment = [
        {
          name  = "DB_NAME"
          value = var.db_name
        },
        {
          name  = "DB_PORT"
          value = "5432"
        },
        {
        "name": "ECS_CONTAINER_STOP_TIMEOUT",
        "value": "300"  // Example value in seconds
        },
        {
          name  = "DB_HOST"
          value = aws_db_instance.main.address
        },
      ]
    }
  ])
}


resource "aws_ecs_service" "main" {
  name            = "${var.environment}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.fargate.arn
  desired_count   = 1
  launch_type     = "FARGATE"
#  platform_version = "1.3.0"

  network_configuration {
    subnets         = aws_subnet.private[*].id
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn  # Reference the target group defined in alb.tf
    container_name   = "${var.environment}-container"
    container_port   = 80
  }

  tags = {
    Name = "${var.environment}-ecs-service"
    Environment = var.environment
  }
  depends_on = [
    aws_lb_target_group.main,
    aws_lb_listener.http
  ]
}
