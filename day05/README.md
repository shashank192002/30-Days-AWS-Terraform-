Day05

Terraform Variables
--------------------

Types of variables 
	1. Input
	2. Output
	3. Locals


Why we need variables in Terraform?

To use certain vaules again and again in a file.

1. Input variable

--- An example of a basic variable in Terraform

#Input variable
variable "environment" {
  default = "dev"
  type = string
}


--- Use the variable in the resource

resource "aws_vpc" "sample" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Environment = "var.environment" -- mention like this using var and its local name.
    Name = "Dev-VPC"
  }
}



2. Local variable

These variables are internal to your module. They are used to assign a name to an expression

--- An example of locals

#Local variable
locals {	
  # Logic happens here: combining a variable with a hardcoded string
  bucket_name = "${var.channel}-bucket-${var.environment}-${var.region}"
  vpc_name = "${var.environment}-VPC-${var.region}"
  
}


#Create s3 bucket
resource "aws_s3_bucket" "first_bucket" {
  bucket = local.bucket_name

  tags = {
    Name        = local.bucket_name  #Assign the local variable like this
    Environment = var.environment
  }
}



3. Output variables

As name suggest providers output to a values.

For the VPC which we are creating, once your VPC is created I want to get the VPC ID.

We can do this using output variables

output "vpc_id" {
  value = aws_vpc.sample.id		#The vpc resource mentioned in the tf file
}

resource "aws_vpc" "sample" {
  cidr_block = "10.0.0.0/24"
  region = var.region
  tags = {
    Environment = var.environment
    Name = local.vpc_name
  }
}


Once this resource is created in AWS. Terraform will display the vpc id in the terminal.

	-	terraform output
	This displays just the values of output variables
	
	
	
***** Using variables as command line arguments (ENV VARS)

	-	export TF_VAR_environment=stage
	


***** Using terraform.tfvars

Create a terraform.tfvars file and mention the value of the variable. 
Declare the variable in the variable.tf file and then use them in the resource file.	
	
	

***** Using command line arguments

terraform plan -var=environment=prod	
--------------------------------------------------------------------------------------------------------------------------------------------

VARIABLE PRECEDENCE (It is from Low to High)

1. using the default
2. ENV VARIABLES
3. terraform.tfvars
4. terraform.tfvars.json
5. *.auto.tfvars or *.auto.tfvars.json
6. ANY -var or -var-file option 

