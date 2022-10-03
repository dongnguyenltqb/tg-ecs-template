data "tls_certificate" "cluster" {
  depends_on = [
    aws_eks_cluster.cluster
  ]
  url = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "eksCluster" {
  depends_on = [
    aws_eks_cluster.cluster
  ]
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}
