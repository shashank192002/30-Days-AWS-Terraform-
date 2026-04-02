Day06

Terraform Type Constraints.

Different types of data constraints in TF are

1) Strings 		2) Number		3) Bool


4) List :- List of objects of different types like string or number. Duplicate vaules are allowed

variable "cidr_block" {
  type = list(string)		#list of string

  description = "all ipv4 address blocks"
  default = [ "10.0.0.0/16","192.168.0.0/16" ]
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  ip_protocol = "TCP"
  cidr_ipv4 = var.cidr_block[0]		#Use list data type like this
  from_port = 443
}

5) Set :- Similar to lists data type, But duplicate vaules are not allowed.

variable "allowed_region" {
  description = "List of allowed regions"
  type = set(string)
  default = [ "us-east-1","us-west-2", "us-west-2","us-west-1"]
}

resource "aws_instance" "ec2" {
  count = var.instance_count
  region = tolist(var.allowed_region)[0]		#Access value of set like this in resource.
} 

NOTE :- The elements of set cannot be accessed by any index or key. Hence we have to use function tolist() to typecast it as List.


6) Maps :- Uses key and value pair to store values. You can store tags here.

#map data type
variable "tags" {
  type = map(string)
  default = {
    Name = "tags"
    Environment = "dev"
    created_by = "terraform"
  }
}

resource "aws_instance" "ec2" {
  tags = var.tags
}  


7) Tuple :- similar to set but we can have multiple data types inside it 

#tuple data type example
variable "ingress_values" {
  type = tuple([ number,string,number])
  default = [ 443, "TCP", 443 ]
}



8) Object :- Its a key value pair of different types of data. Similar to maps but can have multiple data types
You have to mention name and data type of each value you are going to use.

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

resource "aws_instance" "ec2" {
  count = var.config.instance_count		#Access it like this resource
  #region = tolist(var.allowed_region)[0]
  region = var.config.region
  ami           = "${var.image}"

  instance_type = var.allowed_vm_type[2]
  
  tags = var.tags

  monitoring = var.config.monitoring	#Access it like this resource
  
  
  
  
  NOTE :- 
  Wherever there is a map access it using the key
  
  Wherever there is a list access it with the index
  
  Set cannot be accessed by index, convert it to list to access using index.
