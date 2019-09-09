terragrunt = {
  remote_state {
    backend = "s3"
    config {
      bucket     = "demoecs-385238ad5d7de613f414"
      key        = "${path_relative_to_include()}/terraform.tfstate"
      region     = "ap-southeast-2"
      encrypt    = true
      dynamodb_table = "terraform-lock-table"
    }
  }
}

aws_region = "ap-southeast-2"

availability_zones = [
  "ap-southeast-2a",
  "ap-southeast-2b",
  "ap-southeast-2c",
]