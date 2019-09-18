variable "aws_region" {
  description = "The AWS region where this infrastructure lives"
  default     = "ap-southeast-2"
}

variable "prefix" {
  description = "Prefix used for all resource names"
  default     = "demoEcs"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availablity Zones"
  default = [
    "ap-southeast-2a",
    "ap-southeast-2b",
    "ap-southeast-2c"
  ]
}

variable "subnet_address_bits" {
  description = "Number of bits to address per subnet"
  default = 8
}

variable "public_subnets_address_offset" {
  description = "Address start point creating public subnets. Ensure that this does not overlap"
  default = 0
}

variable "private_subnets_address_offset" {
  description = "Address start point for creating private subnets. Ensure no overlap"
  default = 100
}
variable "data_subnets_address_offset" {
  description = "Address start point for creating data subnets. Ensure no overlap"
  default = 50
}

variable "app_port" {
  description = "ECS App Port"
  default = 9000
}

variable "rds_port" {
  description = "RDS Port"
  default = 5432
}

variable "app_image" {
  description = "ECS app image"
  default = ""
}

variable "fargate_sonarqube_cpu" {
  description = "ECS app cpu"
  default = 512
}

variable "fargate_sonarqube_memory" {
  description = "ECS app memory"
  default = 2048
}

variable "fargate_sonarqube_log" {
  description = "ECS cloudwatch log group"
  default     = "/ecs/sonarqube-fargate"
}


variable "openvpn" {
    default = {
        host_count        = 1
        ami_image         = "ami-0fd3faa55c9fd9517"
        type              = "t2.micro"
        key_name          = "vpn-key"
        vpn_zone          = "ap-southeast-2a"
    }
}