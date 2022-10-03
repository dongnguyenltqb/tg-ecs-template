resource "aws_eks_node_group" "group1" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "public1A"
  disk_size       = 20
  instance_types  = ["t3.small"]
  labels = merge(local.tags, var.tags, {
    NodeGroup = "public1A"
  })
  tags = merge(local.tags, var.tags, {
    Name = format("%sNodeGroup", var.cluster_name)
  })
  tags_all = merge(local.tags, var.tags, {
    Name = format("%sNodeGroup", var.cluster_name)
  })
  node_role_arn = aws_iam_role.eksNodeRole.arn
  ami_type      = "AL2_x86_64"
  subnet_ids = [
    aws_subnet.tf-1a-public.id
  ]
  remote_access {
    ec2_ssh_key               = aws_key_pair.jump_key.id
    source_security_group_ids = [aws_security_group.jump.id]
  }

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 0
  }

  lifecycle {
    ignore_changes = [scaling_config.0.desired_size]
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eksNodeRole_AmazonEKS_CNI_Policy_attachment,
    aws_iam_role_policy_attachment.eksNodeRole_AmazonEC2ContainerRegistryReadOnlyPolicy_attachment
  ]
}
