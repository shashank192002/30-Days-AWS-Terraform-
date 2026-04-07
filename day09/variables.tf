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

variable "image" {
  type = string
}

variable "bucket_name" {
  type = list(string)
  default = ["my-unquie-bucket-day08-12345","my-unquie-bucket-day08-1234557"]
}


variable "bucket_name_set" {
  type = set(string)
  default = ["my-unquie-bucket-day08-1234560","my-unquie-bucket-day08-1234569"]
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
  default = [ "us-east-1","us-west-2", "eu-west-2","us-west-1"]
}

#map data type
variable "tags" {
  type = map(string)
  default = {
    Name = "tags"
    Environment = "dev"
    created_by = "terraform"
    #Compliance = "yes"
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


variable "ingress_rules" {
  description = "List of ingress rules for security group"
  type = list(object({
    from_port = number
    to_port = number
    protocol = string
    cidr_blocks = list(string)
    description = string
  }))
  default = [{
    from_port = 80
    to_port = 80
    protocol = "HTTP"
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "HTTP ingress rule"
  },
  {
    from_port = 443
    to_port = 443
    protocol = "HTTPS"
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "HTTPS ingress rule"
  }
  ]
}