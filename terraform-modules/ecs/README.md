# How to use
### ECS needs to have ec2 policy

```terraform
#----- ECS --------
module "ecs" {
  source = "..\/..\/snapshot\/jimmypagesolo-terraform-modules-b56aea577444"

  name = local.name
  container_insights = true

  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT",
    aws_ecs_capacity_provider.prov1.name]

  default_capacity_provider_strategy = [
    {
      capacity_provider = aws_ecs_capacity_provider.prov1.name
      # "FARGATE_SPOT"
      weight = "1"
    }]

  tags = {
    Environment = local.environment
  }
}

module "ec2_profile" {
  source = "../../modules/ecs-instance-profile"

  name = local.name

  tags = {
    Environment = local.environment
  }
}

resource "aws_ecs_capacity_provider" "prov1" {
  name = "prov1"

  auto_scaling_group_provider {
    auto_scaling_group_arn = module.asg.autoscaling_group_arn
  }

}

#----- ECS  Services--------
module "hello_world" {
  source = "./service-hello-world"

  cluster_id = module.ecs.ecs_cluster_id
}

#----- ECS  Resources--------

#For now we only use the AWS ECS optimized ami <https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html>
data "aws_ami" "amazon_linux_ecs" {
  most_recent = true

  owners = [
    "amazon"]

  filter {
    name = "name"
    values = [
      "amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name = "owner-alias"
    values = [
      "amazon"]
  }
}

module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.0"

  name = local.ec2_resources_name

  # Launch configuration
  lc_name = local.ec2_resources_name
  use_lc = true
  create_lc = true

  image_id = data.aws_ami.amazon_linux_ecs.id
  instance_type = "t2.micro"
  security_groups = [
    module.vpc.default_security_group_id]
  iam_instance_profile_name = module.ec2_profile.iam_instance_profile_id
  user_data = templatefile("${path.module}/templates/user-data.sh", {
    cluster_name = local.name
  })

  # Auto scaling group
  vpc_zone_identifier = module.vpc.private_subnets
  health_check_type = "EC2"
  min_size = 0
  max_size = 2
  desired_capacity = 0
  # we don't need them for the example
  wait_for_capacity_timeout = 0

  tags = [
    {
      key = "Environment"
      value = local.environment
      propagate_at_launch = true
    },
    {
      key = "Cluster"
      value = local.name
      propagate_at_launch = true
    },
  ]
}
```
