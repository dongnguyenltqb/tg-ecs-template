// Task execution role that the Amazon ECS container agent and the Docker daemon can assume.
// Fetch secret from secret manager
resource "aws_iam_role" "execution_task" {
  name = format("%sTaskExecutionRole", var.cluster_name)
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
  tags     = merge(local.tags, var.tags)
  tags_all = merge(local.tags, var.tags)
}

resource "aws_iam_role_policy_attachment" "execution_task_managed" {
  role       = aws_iam_role.execution_task.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "execution_task_custom" {
  name = format("%sTaskExecutionRoleSecretReadPolicy", var.cluster_name)
  policy = jsonencode({
    "Version" : "2012-10-17"
    "Statement" : [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = [
          aws_secretsmanager_secret.this.id
        ]
      }
    ]
  })
  tags     = merge(local.tags, var.tags)
  tags_all = merge(local.tags, var.tags)
}

resource "aws_iam_role_policy_attachment" "execution_task_secret_read_policy_attachment" {
  role       = aws_iam_role.execution_task.name
  policy_arn = aws_iam_policy.execution_task_custom.arn
}

