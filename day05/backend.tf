terraform {
  
backend "s3" {
    bucket = "techtutwithshashank-terraform-state"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }

} 