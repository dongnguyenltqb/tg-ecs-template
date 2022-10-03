// Provides Kubernetes the permissions it requires to manage resources on your behalf
resource "aws_iam_role" "eksClusterRole" {
  name = format("%sEKSClusterRole", var.cluster_name)
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "eks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = merge(local.tags, var.tags)
}

resource "aws_iam_role_policy_attachment" "eksClusterRole_AmazonEKSClusterPolicy_attachment" {
  role       = aws_iam_role.eksClusterRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
