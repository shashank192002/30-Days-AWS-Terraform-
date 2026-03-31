Day 04

Terraform State file and Remote Backend



How Terraform updates infra?

Terraform compares your desired state to your actual state.
terraform.tfstate is a JSON file that stores the current state of your infrastructure

In simple terms 
	Your .tf file = desired state
	terraform.tfstate = actual known state
	

Its a confidential file which contains some important data. So you cannot store it onto your local machine


-----------REMOTE Backend.-------------

We store the terraform state file remotely for eg in an s3 bucket as a file. So instead of using a local backend you use a remote backend.

When you run tf commands it will go and check your remote backend file in the s3 bucket and it will compare it will the actual infra and make changes


IMP POINTS TO REMEMBER
1. store state file to remote backend
2. do not update/delete the file manually
3. state locking (once the tfstate file is used by a process dont use it elsewhere so that multiple users cannot execute on the same infra
So it will lock the terraform state file and once the process complete after then release the lock)

4. isolation of statefile (make sure statefiles are isolated as per envs dev,test,prod)
5. regular backup (in case file is accidently corrupted or deleted)


main.tf
-------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "techtutwithshashank-terraform-state" 		-----> state bucket which maintains terraform.tfstate file
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true									-----> whether to use lock file or not for state locking
  }
}


When you run tf plan with this, It will throw error stating techtutwithshashank-terraform-state this bucket is not created.
This is because, the s3 bucket should already be created manually or using cicd pipeline by you because this bucket should already be available. coz it haves state of your terraform

DO NOT KEEP THIS BUCKET AS A TERRAFORM RESOURCE. IT SHOULD BE CREATED BEFOREHAND.

Once this s3 bucket is created Terraform will configure this bucket as backend. Terraform will automatically use this backend unless the backend configuration changes.



Some basics command for State

# List resources in state
terraform state list 	( Shows where state file is, in our case it is in S3)
o/p :- aws_s3_bucket.first_bucket

# Show detailed state information
terraform state show aws_s3_bucket.first_bucket

# Remove resource from state (without destroying)
terraform state rm <resource_name>

# Move resource to different state address
terraform state mv <source> <destination>

# Pull current TF state and display
terraform state pull

Whenever there is a State lock when 2 users have simulatneously applied the same config file 

Run this command

# Force-unlock a stuck state lock
terraform force-unlock <lock-id>

The lock id will be displayed on the terminal. But be careful, because this forcefully unlocks the stuck state. So the other person from your team will lose the changes he made

First, make sure nobody else is actually running Terraform on this state. Check with your team. If someone is legitimately running an apply, wait for them to finish.

If the lock is orphaned (the process that held it crashed), you can force-unlock it
----------What is S3 Native State Locking?----------------

Starting with Terraform 1.10 you no longer need Dynamo DB for state locking. Terraform now supports S3 native state locking using Amazon S3's Conditional writes feature

How It Works
S3 native state locking uses the If-None-Match HTTP header to implement atomic operations:

When Terraform needs to acquire a lock, it attempts to create a lock file in S3
S3 conditional writes check if the lock file already exists
If the lock file exists, the write operation fails, preventing concurrent modifications
If the lock file doesn't exist, it's created successfully and the lock is acquired
When the operation completes, the lock file is deleted (appears as a delete marker with versioning)

