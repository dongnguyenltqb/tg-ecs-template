// Instance Role help ec2 instance register itself to ecs cluster
resource "aws_iam_role" "ec2_instances" {
  name = format("%sEc2InstanceRoleForAsg", var.cluster_name)
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
  tags     = merge(local.tags, var.tags)
  tags_all = merge(local.tags, var.tags)
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerServiceforEC2Role_attachment" {
  role       = aws_iam_role.ec2_instances.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs" {
  name     = format("%sEc2InstanceRoleForAsg", var.cluster_name)
  role     = aws_iam_role.ec2_instances.name
  tags     = merge(local.tags, var.tags)
  tags_all = merge(local.tags, var.tags)
}

