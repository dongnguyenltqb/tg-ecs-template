resource "aws_iam_role" "this" {
  name = format("%sInstanceCloudwatchRoleForRds", var.name)
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "monitoring.rds.amazonaws.com"
        },
        "Effect" : "Allow",
      }
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"]
  tags                = var.tags
}
