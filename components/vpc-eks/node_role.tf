// Allows Amazon EKS worker nodes to connect to Amazon EKS Clusters.
// Provides read-only access to Amazon EC2 Container Registry repositories.
// Provides the Amazon VPC CNI Plugin (amazon-vpc-cni-k8s) the permissions it requires to modify the IP address configuration on your EKS worker nodes
resource "aws_iam_role" "eksNodeRole" {
  name = format("%sEKSNodeRole", var.cluster_name)
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = merge(local.tags, var.tags)
}

resource "aws_iam_role_policy_attachment" "eksNodeRole_AmazonEKSWorkerNodePolicy_attachment" {
  role       = aws_iam_role.eksNodeRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eksNodeRole_AmazonEC2ContainerRegistryReadOnlyPolicy_attachment" {
  role       = aws_iam_role.eksNodeRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eksNodeRole_AmazonEKS_CNI_Policy_attachment" {
  role       = aws_iam_role.eksNodeRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
