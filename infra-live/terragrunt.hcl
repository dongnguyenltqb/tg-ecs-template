remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "skip"
  }
  config = {
    bucket = "copper-ecs-template-tfgrunt-state"

    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "ap-southeast-1"
  }
}
