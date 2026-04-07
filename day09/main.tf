resource "aws_instance" "example" {
  ami = "ami-0ff8a91507f77f867"
  count = var.instance_count
  #instance_type = "t3.micro"
  
  #Conditional expression
  instance_type = var.environment == "dev" ? "t2.micro" : "t3.micro"

  tags = var.tags
}



#Dynamic block example.
resource "aws_security_group" "ingress" {
  name = "sg"

    dynamic "ingress"  {
        for_each = var.ingress_rules
        content {
            from_port = ingress.value.from_port
            to_port = ingress.value.to_port
            cidr_blocks = ingress.value.cidr_blocks
            protocol = ingress.value.protocol
          
        }

  }

  
}

resource "aws_instance" "example" {
  ami = "ami-0ff8a91507f77f867"
  count = var.instance_count
  #instance_type = "t3.micro"
  
  instance_type = var.environment == "dev" ? "t2.micro" : "t3.micro"

  tags = var.tags
}

#Here we use the splat expression inside locals block using for the aws_instance resource using the [*] before the .id
locals {
  all_instance_ids = aws_instance.example[*].id
}

output "instance" {
  value = local.all_instance_ids
}

