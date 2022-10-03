## Terragrunt example

1. Structure

- /code
  - /components
    - /network
    - /ec2
  - /modules
    - /vpc
- /infra-live
  - /dev
    - /network
    - /ec2
  - /prod
    - /network
    - /ec2
- /vars
  - dev.tfvars
  - prod.tfvars

2. Command

- to setup remote tf state bucket

  ```shell
  ./setup-tf-state.sh
  ```

- to spin up infra for an environment like dev or staging
  ```shell
  cd live/ENV
  tg run-all apply -var-file=$PATH_TO_VAR_FILE
  ```
