resource "aws_iam_instance_profile" "this" {
  depends_on = [
    aws_iam_role.this
  ]
  name = var.profile_name
  role = aws_iam_role.this.name
  tags = merge(local.tags, var.tags)
}

resource "aws_iam_role" "this" {
  name = format("%sRole", var.profile_name)
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Effect" : "Allow",
      }
    ]
  })
  tags = merge(local.tags, var.tags)
}

resource "aws_iam_policy" "this" {
  count  = length(var.custom_policy_documents)
  name   = format("%sRolePolicy%s", var.profile_name, count.index)
  policy = var.custom_policy_documents[count.index]
  tags   = merge(local.tags, var.tags)
}

resource "aws_iam_policy_attachment" "custom" {
  depends_on = [
    aws_iam_policy.this
  ]
  count      = length(var.custom_policy_documents)
  name       = format("%sRolePolicy%sAttachment", var.profile_name, count.index)
  roles      = [aws_iam_role.this.name]
  policy_arn = aws_iam_policy.this[count.index].arn
}

resource "aws_iam_policy_attachment" "managed" {
  depends_on = [
    aws_iam_role.this
  ]
  count      = length(var.managed_policy_arns)
  name       = format("%sRoleAWSManagedPolicy%sAttachment", var.profile_name, count.index)
  roles      = [aws_iam_role.this.name]
  policy_arn = var.managed_policy_arns[count.index]
}
