Day 03 :- Create AWS bucket using Terraform.

Before creating resources, you need to configure AWS credentials for Terraform to authenticate with AWS APIs.


Create a new user for s3, and give it all permissions related to s3 in AWS. Generate access key for it and using "aws configure" add that in CLI.


main.tf 
------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

#Create s3 bucket
resource "aws_s3_bucket" "first_bucket" {
  bucket = "techtutwithshashank-bucket-12345"

  tags = {
    Name        = "My bucket"
    Environment = "DEV"
  }
}


After this run 

	-	terraform init
	
	- 	terraform plan

These are the checks which you have to run before anything gets creates in the Cloud.

To actually create resource in Cloud use command 

	-	terraform apply
	
This will ask you for a prompt like yes/no means should we procced or not. 
If you select NO the process will be aborted, 
You have to write "yes" in terminal once prompted.

To skip the prompting use command 
	-	terraform apply --auto-approve
	
Using this it will directly apply the changes.


Now it will create your S3 bucket in the AWS Cloud.


If you make any changes to your terraform file and again apply using the above command.
Terraform will detect the change and it will mention all the changes in the terminal and make changes as per mentioned.



To delete the resource use command

	-	tf destroy

