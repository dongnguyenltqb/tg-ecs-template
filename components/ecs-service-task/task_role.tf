// Task role allows your Amazon ECS container task to make calls to other AWS services
resource "aws_iam_role" "task" {
  name = format("ECS%sService%sTaskRole", var.cluster_name, var.service_name)
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  tags     = merge(local.tags, var.tags)
  tags_all = merge(local.tags, var.tags)
}

resource "aws_iam_policy" "task_custom" {
  name = format("ECS%sService%sTaskRolePolicy", var.cluster_name, var.service_name)
  policy = jsonencode({
    "Version" : "2012-10-17"
    "Statement" : [
      {
        Effect = "Allow",
        Action = [
          "s3:Get"
        ],
        Resource = ["*"]
      }
    ]
  })
  tags     = merge(local.tags, var.tags)
  tags_all = merge(local.tags, var.tags)
}

resource "aws_iam_role_policy_attachment" "task_attachment" {
  role       = aws_iam_role.task.name
  policy_arn = aws_iam_policy.task_custom.arn
}

