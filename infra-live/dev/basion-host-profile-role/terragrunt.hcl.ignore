include "dev" {
  path = find_in_parent_folders("dev.hcl")
}

include "root" {
  path = "${dirname("../../")}/terragrunt.hcl"
}

terraform {
  source = "../../../components//jump-server-role"
}

inputs = {
  profile_name        = "cafeJumpEC2InstanceProfileRole"
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess"]
  tags = {
    Project   = "Cafe"
    Component = "JumpServer"
  }
}