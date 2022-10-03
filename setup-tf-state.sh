#!/bin/bash
set -ex
cd s3-remote-backend
terraform init --reconfigure
terraform apply
