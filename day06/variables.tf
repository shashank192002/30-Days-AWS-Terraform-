# Define variables
variable "environment" {
  default = "dev"
  type = string
}

variable "channel" {
  default = "ttws"
  type = string
}


locals {
  bucket_name = "${var.channel}-bucket-${var.environment}-${var.region}"
  vpc_name = "${var.environment}-VPC-${var.region}"
  
}

variable "region" {
  type = string
  default = "us-east-1"
}

#Number data type example
variable "instance_count" {
  description = "Number of instance to create"
  type = number 
}

#Boolean data type example
variable "monitoring_enabled" {
  default = true
  type = bool
}

variable "ass_pub_ip" {
  type = bool
  default = true
}

#List data type examples
variable "cidr_block" {
  type = list(string)

  description = "all ipv4 address blocks"
  default = [ "10.0.0.0/16","192.168.0.0/16" ]
}

variable "allowed_vm_type" {
  description = "Different type of VM's"
  type = list(string)
  default = [ "t2.micro","t3.micro","t2.small" ]
}

#Set example

variable "allowed_region" {
  description = "List of allowed regions"
  type = set(string)
  default = [ "us-east-1","us-west-2", "us-west-2","us-west-1"]
}

#map data type
variable "tags" {
  type = map(string)
  default = {
    Name = "tags"
    Environment = "dev"
    created_by = "terraform"
  }
}

#tuple data type example
variable "ingress_values" {
  type = tuple([ number,string,number])
  default = [ 443, "TCP", 80 ]
}

#Object type
variable "config" {
  type = object({
    region = string
    monitoring = bool
    instance_count = number
  })

  default = {
    region = "us-east-1" 
    monitoring = true
    instance_count = 1
  }
}