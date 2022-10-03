// Instance Role help ec2 instance register itself to ecs cluster
resource "aws_iam_role" "ec2_instances" {
  name = "ecsInstanceRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerServiceforEC2Role_attachment" {
  role       = aws_iam_role.ec2_instances.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs" {
  name = format("ecsInstanceProfileRoleFor%s", var.cluster_name)
  role = aws_iam_role.ec2_instances.name
}

// Task execution role that the Amazon ECS container agent and the Docker daemon can assume.
// Fetch secret from secret manager
resource "aws_iam_role" "execution_task" {
  name = "ecsExcutionTaskRole"
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
}

resource "aws_iam_role_policy_attachment" "AmazonECSTaskExecutionRolePolicy_execution_task_attachment" {
  role       = aws_iam_role.execution_task.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


// Task role allows your Amazon ECS container task to make calls to other AWS services
resource "aws_iam_role" "task" {
  name = "ecs_task_role"
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
}

resource "aws_iam_policy" "execution_task_secret_read" {
  name = "execution_task_secret_read_policy"
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
          aws_secretsmanager_secret.app.id
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "execution_task_secret_read_policy_attachment" {
  role       = aws_iam_role.execution_task.name
  policy_arn = aws_iam_policy.execution_task_secret_read.arn
}

