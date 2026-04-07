variable "all_ingress_values" {
  type = list(object({
    from_port = number
    to_port = number
    cidr_blocks = list(string)
    protocol = string
  }))

  default = [ {
    from_port = 80
    to_port = 80
    cidr_blocks = [ "10.0.0.0/16" ]
    protocol = "TCP"
  }, 
  {
    from_port = 443
    to_port = 443
    cidr_blocks = [ "10.0.0.0/16" ]
    protocol = "TCP"
  }
  ]
}

variable "env" {
    default = "dev"
}


resource "aws_security_group" "aws_sg" {
  name = "my-sg"

  dynamic "ingress" {
    for_each = var.all_ingress_values

    content {
        from_port = ingress.value.from_port
        to_port = ingress.value.to_port
        cidr_blocks = ingress.value.cidr_blocks
        protocol = ingress.value.protocol
      
    }
  }

}

resource "aws_instance" "server" {
    ami = "ami-0ff8a91507f77f867"

    instance_type = var.env == "prod" ? "m5.large" : "t2.micro"

    
}

output "app_ips" {
  value = aws_instance.app_server[*].private_ip
}

/*output "ingress" {
  value = aws_security_group.aws_sg.ingress[*]
}*/
