## Terraform

modify `sample.tfvars`

include:

- ECS cluster
- ECS task definition
- ECS service
- ALB
- ALB target group
- ALB target group attachment
- ALB listener
- ALB listener rule
- IAM role for ecsCluster
- IAM task execution role
- Secret manager

run: `terraform apply -var-file dev.tfvar`
