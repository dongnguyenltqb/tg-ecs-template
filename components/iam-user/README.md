## IAM USER

1. Introduce

this purpose of this component is provider credential for developer to interact with aws service.
remember to limited permission

this module grant permission to user on 2 parts

- custom policy

```shell
custom_policy_documents = [
    // secret backend read
    jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret"
          ],
          "Resource" : [
            var.backend_secret_id
          ]
        }
      ]
    }),
    // secret static read
    jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret"
          ],
          "Resource" : [
            var.static_secret_id
          ]
        }
      ]
    }),
    // backend ecr repo
    jsonencode({
      Version = "2012-10-17",
      Statement : [
        {
          Effect = "Allow",
          Action = [
            "ecr:Get*",
            "ecr:List*",
            "ecr:Describe*",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer"
          ],
          Resource = var.backend_ecr_arn
        },
        {
          Effect   = "Allow",
          Action   = "ecr:GetAuthorizationToken",
          Resource = "*"
        }
      ]
    }),
    // static ecr repo
    jsonencode({
      Version = "2012-10-17",
      Statement : [
        {
          Effect = "Allow",
          Action = [
            "ecr:Get*",
            "ecr:List*",
            "ecr:Describe*",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer"
          ],
          Resource = var.static_ecr_arn
        },
        {
          Effect   = "Allow",
          Action   = "ecr:GetAuthorizationToken",
          Resource = "*"
        }
      ]
    }),
    // ssm
    jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "ssmmessages:CreateControlChannel",
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenControlChannel",
            "ssmmessages:OpenDataChannel"
          ]
          Resource = "*"
        },
        {
          Effect = "Allow",
          Action = [
            "s3:GetEncryptionConfiguration"
          ]
          Resource = "*"
        }
      ]
    }),
    // log group
    jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "logs:CreateLogStream",
            "logs:DescribeLogStreams",
            "logs:PutRetentionPolicy",
            "logs:PutLogEvents"
          ]
          Resource = [
            var.log_group_arn,
            "${var.log_group_arn}/*",
            "${var.log_group_arn}:*",
          ]
        }
      ]
    })
  ]
```

- aws managed policy arn

```shell
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
```

2. Example code for terragrunt

```hcl
terraform {
  source = "git::https://github.com/dongnguyenltqb/terraform-infra-code-public.git//components/iam-user"
}

inputs = {
  name = "msiProductionDevAccount"
  tags = {
    project  = msi
    environtment = production
  }
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  custom_policy_documents = [
    jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret"
          ],
          "Resource" : [
            var.backend_secret_id
          ]
        }
      ]
    })
  ]
}

include "root" {
  path = "${dirname("../../")}/terragrunt.hcl"
}

```
