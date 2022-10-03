resource "aws_iam_role" "this" {
  name               = format("%sRole", var.role_name)
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = var.tags
}

resource "aws_iam_policy" "this" {
  count  = length(var.custom_policy_documents)
  name   = format("%sRolePolicy%s", var.role_name, count.index)
  policy = var.custom_policy_documents[count.index]
  tags   = var.tags
}

resource "aws_iam_policy_attachment" "custom" {
  depends_on = [
    aws_iam_policy.this
  ]
  count      = length(var.custom_policy_documents)
  name       = format("%sRolePolicy%sAttachment", var.role_name, count.index)
  roles      = [aws_iam_role.this.name]
  policy_arn = aws_iam_policy.this[count.index].arn
}

resource "aws_iam_policy_attachment" "managed" {
  depends_on = [
    aws_iam_role.this
  ]
  count      = length(var.managed_policy_arns)
  name       = format("%sRoleAWSManagedPolicy%sAttachment", var.role_name, count.index)
  roles      = [aws_iam_role.this.name]
  policy_arn = var.managed_policy_arns[count.index]
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_oidc_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.service_account_namespace}:${var.service_account_name}"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_oidc_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
    principals {
      identifiers = [var.cluster_oidc_arn]
      type        = "Federated"
    }
  }
}


