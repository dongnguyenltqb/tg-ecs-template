#!/bin/bash
find . -type d -name "*.terragrunt-cache*" -exec rm -rf {} \;
