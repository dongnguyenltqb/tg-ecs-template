// Provide permission for AWS load balancer controller pod
// to create ingress 
resource "aws_iam_role" "eksAwsLoadBalancerController" {
  name               = format("%sAWSLoadBalancerController", var.cluster_name)
  assume_role_policy = data.aws_iam_policy_document.eksAwsLoadBalancerControllerPolicyDocument.json
  tags               = merge(var.tags, local.tags)
}

resource "aws_iam_role_policy" "eksAwsLoadBalancerControllerPolicy" {
  name = format("%sAWSLoadBalancerControllerIAMPolicy", var.cluster_name)
  role = aws_iam_role.eksAwsLoadBalancerController.id

  policy = file("aws-load-balancer-controller-policy.json")
}

data "aws_iam_policy_document" "eksAwsLoadBalancerControllerPolicyDocument" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eksCluster.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eksCluster.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eksCluster.arn]
      type        = "Federated"
    }
  }
}
