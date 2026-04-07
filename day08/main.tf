#create_before_destroy lifecycle rule example
resource "aws_instance" "name" {
  ami = "ami-0ff8a91507f77f867"
  instance_type = var.allowed_vm_type[1]


  region = var.region

  lifecycle {
    create_before_destroy = true
  }
}


#prevent_destroy lifecycle rule example
resource "aws_instance" "name" {
  ami = "ami-0ff8a91507f77f867"
  instance_type = var.allowed_vm_type[1]


  region = var.region

  lifecycle {
	  prevent_destroy = true
  }
}


#ignore_changes lifecycle rule example
resource "aws_autoscaling_group" "app_servers" {
  name               = "app-servers-asg"
  min_size           = 1
  max_size           = 5
  desired_capacity   = 2
  health_check_type  = "EC2"
  availability_zones = [ "us-east-1a" ,"us-east-1b"]

  launch_template {
    id      = aws_launch_template.app_server.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [
      desired_capacity,
    ]
  }
}

#replaced_triggered_by lifecycle rule
# EC2 Instance that gets replaced when security group changes
resource "aws_instance" "app_with_sg" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = merge(
    var.resource_tags,
    {
      Name = "App Instance with Security Group"
      Demo = "replace_triggered_by"
    }
  )

  # Lifecycle Rule: Replace instance when security group changes
  # This ensures the instance is recreated with new security rules
  lifecycle {
    replace_triggered_by = [
      aws_security_group.app_sg.id
    ]
  }
}

#Post condition example
resource "aws_s3_bucket" "compliance_bucket" {
  bucket = "compliance-bucket-${var.environment}-${var.region}"

  tags = var.tags

  # Lifecycle Rule: Validate bucket has required tags after creation
  # This ensures compliance with organizational tagging policies
  lifecycle {
    postcondition {
      condition     = contains(keys(var.tags), "Compliance")
      error_message = "ERROR: Bucket must have a 'Compliance' tag for audit purposes!"
    }

  }
}