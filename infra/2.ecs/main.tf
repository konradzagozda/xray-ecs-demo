resource "aws_ecs_cluster" "app_with_xray" {
  name = "app_with_xray"
}

resource "aws_ecs_task_definition" "app_with_xray" {
  family                   = "app_with_xray"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  cpu                      = 512
  memory                   = 3072

  container_definitions = jsonencode([
    {
      name      = "app_with_xray"
      image     = "817861099197.dkr.ecr.us-west-2.amazonaws.com/app-with-xray"
      cpu       = 0
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "app_with_xray" {
  name            = "app_with_xray"
  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.app_with_xray.id
  task_definition = aws_ecs_task_definition.app_with_xray.arn
  desired_count   = 1
  wait_for_steady_state = true

  network_configuration {
    subnets = data.aws_subnets.default_subnets.ids
    assign_public_ip = true
  }
}
