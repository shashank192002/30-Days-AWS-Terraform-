











variable "image" {
  type = string
  description = "Ec2 image vaule"
}



resource "aws_instance" "ec2" {
  count = var.config.instance_count
  #region = tolist(var.allowed_region)[0]
  region = var.config.region
  ami           = "${var.image}"

  instance_type = var.allowed_vm_type[2]
  
  tags = var.tags

  monitoring = var.config.monitoring
  associate_public_ip_address = var.ass_pub_ip
  
}

resource "aws_security_group" "allow_tls" {
  name = "allow_tls"
  description = "Allow inbound traffic and all outbound traffic"

  tags = {
    "Name" = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4 = var.cidr_block[0]
  ip_protocol = var.ingress_values[1]
  from_port = var.ingress_values[0]
  to_port = var.ingress_values[2]
}


resource "aws_vpc_security_group_egress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  ip_protocol = "TCP"
  cidr_ipv4 = var.cidr_block[1]
  from_port = 443
}