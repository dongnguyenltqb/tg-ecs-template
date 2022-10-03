region  = "ap-southeast-1"
vpc_id  = "vpc-id"
subnets = ["subnet-0464c", "subnet-dfb9", "subnet-f041"]

cluster_name              = "x1"
be_service_name           = "backend-api"
be_task_definition_family = "backend-task-def"
container_name            = "nodejs"
image_url                 = "public.ecr.aws/g3k3o5v3/testport3000:latest"
be_container_port         = 3000
secrets = {
  Age = "25"
}
