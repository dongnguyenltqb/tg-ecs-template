resource "aws_eks_cluster" "cluster" {
  name = var.cluster_name
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]
  role_arn = aws_iam_role.eksClusterRole.arn
  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = false
    public_access_cidrs = [
      "0.0.0.0/0",
    ]
    security_group_ids = [
      aws_security_group.cluster.id
    ]
    subnet_ids = [
      aws_subnet.tf-1a-public.id,
      aws_subnet.tf-1a-private.id,
      aws_subnet.tf-1b-public.id,
      aws_subnet.tf-1b-private.id,
      aws_subnet.tf-1c-public.id,
      aws_subnet.tf-1c-private.id,
    ]
  }
  tags = merge(local.tags, var.tags)
}

resource "aws_eks_addon" "cni" {
  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "kubeproxy" {
  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "core-dns" {
  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "coredns"
}

resource "aws_eks_addon" "ebs-csi" {
  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "aws-ebs-csi-driver"
}
