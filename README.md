Terraform AWS ECS Completee
===

[![Terraform](https://img.shields.io/badge/terraform-v0.11.14-brightgreen)](http://terraform.io)
[![Terragrunt](https://img.shields.io/badge/terragrunt-v0.18.0-brightgreen)](https://github.com/gruntwork-io/terragrunt)

This repository contains Terraform scripts for provisioning a complete AWS ECS environment in a given AWS account.  In addition, this enviroment has a inspec profile to audit the environment.

Execute
---

```
export AWS_PROFILE=<profile name>
terragrunt init
terragrunt plan
terragrunt apply
```

Terraform State
---

Terraform state is stored in a S3 bucket on AWS account.



