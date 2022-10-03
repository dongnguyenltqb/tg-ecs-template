resource "aws_iam_user" "this" {
  name = var.name
  tags = merge(local.tags, var.tags)
}

resource "aws_iam_policy" "this" {
  count  = length(var.custom_policy_documents)
  name   = format("%sPolicy%s", var.name, count.index)
  policy = var.custom_policy_documents[count.index]
  tags   = merge(local.tags, var.tags)
}

resource "aws_iam_access_key" "this" {
  depends_on = [
    aws_iam_user.this
  ]
  user = aws_iam_user.this.name
}


resource "aws_iam_policy_attachment" "custom" {
  depends_on = [
    aws_iam_policy.this
  ]
  count      = length(var.custom_policy_documents)
  name       = format("%sIamUserPolicy%sAttachment", var.name, count.index)
  policy_arn = aws_iam_policy.this[count.index].arn
  users      = [aws_iam_user.this.name]
}

resource "aws_iam_policy_attachment" "managed" {
  depends_on = [
    aws_iam_user.this
  ]
  count      = length(var.managed_policy_arns)
  name       = format("%sIamUserAWSManagedPolicy%sAttachment", var.name, count.index)
  policy_arn = var.managed_policy_arns[count.index]
  users      = [aws_iam_user.this.name]
}
