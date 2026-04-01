# Define variables
variable "environment" {
  default = "dev"
  type = string
}

# Input variable example
variable "channel" {
  default = "ttws"
  type = string
}

#Local variable example
locals {
  bucket_name = "${var.channel}-bucket-${var.environment}-${var.region}"
  vpc_name = "${var.environment}-VPC-${var.region}"
  
}

variable "region" {
  default = "us-east-1"
}