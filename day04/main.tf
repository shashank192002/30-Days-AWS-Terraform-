terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "techtutwithshashank-terraform-state"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
}
# Define variables
variable "environment" {
  default = "dev"
  type = string
}

variable "channel" {
  default = "ttws"
  type = string
}

#Local variable
locals {
  bucket_name = "${var.channel}-bucket-${var.environment}-${var.region}"
  vpc_name = "${var.environment}-VPC-${var.region}"
  
}

#Output variable
output "s3_id" {
  value = aws_s3_bucket.first_bucket.id
}

output "ec2_id" {
  value = aws_instance.ec2.id
}
variable "region" {
  default = "us-east-1"
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  
}

#Create s3 bucket
resource "aws_s3_bucket" "first_bucket" {
  bucket = local.bucket_name

  tags = {
    Name        = local.bucket_name
    Environment = var.environment
  }
}


variable "image" {
  type = string
  description = "Ec2 image vaule"
}



resource "aws_instance" "ec2" {
  region = var.region
  ami           = "${var.image}"

  instance_type = "t2.micro"
  tags = {
    Name = "${var.environment}-EC2"
    Environment = var.environment
  }
}