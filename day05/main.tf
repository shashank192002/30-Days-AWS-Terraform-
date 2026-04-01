








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