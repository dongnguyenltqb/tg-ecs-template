## Terraform

modify `tfvars.example`

include:

- RDS subnet group
- Security group for jump and cluster
- RDS MultiAZ cluster
- A single DB instance

run: `terraform apply -var-file dev.tfvar`
