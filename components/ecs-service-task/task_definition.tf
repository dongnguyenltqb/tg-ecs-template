resource "aws_ecs_task_definition" "this" {
  depends_on = [
    aws_secretsmanager_secret.this
  ]
  family                   = var.be_task_definition_family
  requires_compatibilities = ["EC2"]
  cpu                      = 1024
  memory                   = 1024
  network_mode             = "host"
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  execution_role_arn = aws_iam_role.execution_task.arn
  task_role_arn      = aws_iam_role.task.arn
  # recommend to turn on log for container
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/using_awslogs.html
  container_definitions = jsonencode(
    [
      {
        "name" : var.container_name,
        "image" : var.image_url,
        "cpu" : 1024,
        "memory" : 1024,
        "secrets" : [
          # recommend to store secret in AWS Secrets Manager
          for key, value in var.secrets : {
            "name" : key,
            "valueFrom" : format("%s:%s:%s:", aws_secretsmanager_secret.app.id, key, tolist(aws_secretsmanager_secret_version.version.version_stages)[0])
          }
        ],
        "portMappings" : [
          {
            "containerPort" : var.be_container_port,
            "hostPort" : var.be_container_port,
            "protocol" : "tcp"
          }
        ],
        "essential" : true
      }
    ]
  )
}
