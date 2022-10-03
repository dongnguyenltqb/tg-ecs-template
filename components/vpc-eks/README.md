### Terraform

include:

- VPC, with subnet, route table, internet gate, nat gateway
- IAM role,policy for eks cluster
- IAM role,policy for node cluster
- EKS cluster
- EKS nodegroup
- EC2 jump server
- AWS Load Balancer Controller

variable: copy and edit `.tfvars` file

run:

```
terraform apply -var-file dev.tfvar
```
