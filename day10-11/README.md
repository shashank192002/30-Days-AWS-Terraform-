Day10 Terraform Functions


Terraform uses HCL ( Hashicorp Configuration Language) and it is not exactly a programming language.

We cannot create your own functions in Terraform you have to only use inbuilt functions.



Types of Functions 



1] String functions :- Operations to be performed on strings


a) upper() :- converts strings to uppercase

b) lower() :- converts strings to lowercase

c) trim() :- It trims the mentioned part from the string
		example :- trim ("   assdw  " , " ")
	It trims white spaces as mentioned in the second argument.


d) replace() :- It replaces occurence of a character with additional charcs what we provide.

		eg  replace("hello world "," ","!")
		Here we are saying replace white space with !
		
		
e) substr() :- trim specific strings lengths which you mention
		eg substr("hello",0,3) trim from 0th element to 3-1=2nd element
		o/p :- hel


f) split() :- Split the string on the basis of seperator mentioned
			
			variable "allowed_port" = "80,443,8080,3306"
			
			split(",", var.allowed_port)

Split the string on the seperator "," and return list ["80","443","8080","3306"] 

sg_rules = [ for port in local.port_list:

  {
    name = "port-${port}"
    port = port
    description = "Allow traffic on port ${port}"
  }

]
  
And then using the for loop we iterate through every  value of the list and return a map as mentioned.

----------------------------------------------------------------------------------------------------------------------------
2] Numeric functions :- Operations to be performed on numerics.


a) max() & min() :- They provide the max and min out of the numbers mentioned in the function.

b) abs() :- Provide absolute value of the numeric
		eg abs(-42) 
		o/p :- 42
		
		
		
		
----------------------------------------------------------------------------------------------------------------------------
		

3] Collection functions :- 	Operations to be performed on list, maps and sets

a)	length() :- calculates the length of the list or set


b) concat() :- concatinating 2 lists and provide a new list as output. It does not works with strings. It works only with lists and tuples
			eg :- concat([1,2],[3,4])
			

c) merge() :- use for combining multiple maps into single maps and objects

		eg :-  merge({a=1},{b=4},{c=5})
	

----------------------------------------------------------------------------------------------------------------------------


4] Type conversion :- convert one data type to another.

a) toset() :- converts list to set, it also makes sure duplicate vaules are not involved.

		eg :- toset(["a","b","a","c"])
		
		o/p :- toset([
				  "a",
				  "b",
				  "c",
				])
				

b) tonumber() & tostring() :-	converts data types into number and string




Use the command 
				- terraform refresh 
It updates your Terraform state file with the real-world infrastructure values

----------------------------------------------------------------------------------------------------------------------------


Examples :- 

#Tag1
variable "default_tags" {
  default = {
    company = "Techcorp"
    managed_by = "terraform"
  }
}


#Tag2
variable "environment_tags" {
  default = {
    environment = "production"
    cost_center = "cc-123"
  }
}


resource "aws_s3_bucket" "s3" {
  bucket = "hellowtecttutwwithshashank"


  tags = merge(var.default_tags,var.environment_tags)
  
}

Here we are using the merge function to merge values of 2 tags into our s3 bucket tags field.





a) lookup() :- It is used to safely get a values from a map with an option to return a default values if the key does not exists.

variable "instances_size" {
  default = {
    dev = "t2.micro"
    staging = "t3.small"
    prod = "t3.large"
  }
}

****Here we have a instance size variable having multiple sizes depending on the environment

variable "environment" {
  default = "dev"
}

*****And we create a environment variable to decide the environment

locals {
	instance_size = lookup(var.instances_size,var.environment,"t2.micro")
}

****Here we use the lookup function and say "Check the instances_size map var and check it against the value of var.environment. 
If the key exist in the map then use the value of key and if it does not exist use the default values t2.micro "



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Day 11 Terraform Functions Part II



validatiom in terraform


#Example
variable "instances_type" {
  default = "t2.micro"

  validation {
    condition = length(var.instances_type) >= 2 && length(var.instances_type) <= 20
    error_message = "The length is not proper. Kindly change!"
  }

  validation {
    condition = can(regex("^t[2-3]\\."),var.instances_type)
    error_message = "Instance type must start with t2 or t3"
  }
}


Here we are adding some validation for our variable that the length of the variable values should be between 2-20 characters
and the name of the character should start from t2 or t3


What are these functions used for string validation?


		1) regex() :- It used to match a string against a pattern
		   regex(pattern, string) pattern you define rule, string is value you check.
		   
		   
		2) can() :- checks whether an expression runs without error.   
		
		
		3) contains() :- It checks whether a given value exists inside a tuple list or set.
		
^	    start of string (must start with)
$	    end of string    (must end with)
.	    any character
*	    0 or more
+	    1 or more
[a-z]	lowercase letters
[0-9]	digits		



****Using both ^ and $ for exact match

^dev$  		:- Exact match dev1 or prod is rejected



**** Range

[a-z] lowercase range	[A-Z] Uppercase range	[a-zA-Z-0-9] Alphanumeric range


**** Any single character
a.c			That could be abc or a1c or a@c anything


**** | OR condition
dev|prod	:- dev or prod

^(dev|prod)$ :- matches exactly dev OR prod


****Escape characters
^app\.com$		:- It matches app.com not appxcom







#Sensitive credentials

#We create a variable with sensitive as true
variable "credentials" {
  default = "xyz123"
  sensitive = true
}

output "credentials" {
  value = var.credentials
}

If we output the value of this var we will get an error as this is a sensitive data.

But still if you wanr the output of this use sensitive=true in the output block as well


output "credentials" {
  value = var.credentials
  sensitive = true
}


It will show the output as

+ credentials      = (sensitive value)





#Example


#creating a variable for costs with -ve and +ve values.
--------------------------------------------------------
variable "monthly_costs" {
  default = [-50,100,75,200] #-50 is a credit
}

#first run a for loop to get each of the value in a tuple and also use abs() to make it positive.
positive_cost = [for cost in var.monthly_costs: abs(cost) ]

  
#Here we use the spread operator (...) It takes all elements from a list and pass them individually.
max_cost =  max(local.positive_cost...)

min_cost = min(local.positive_cost...) 


Now we can get the output as the sum and max min.


----------------------------------------------------
File handling

config_file_exists = fileexists("./config.json")

#Use the fileexists() function to check if the file exists or not.



config_data = local.config_file_exists ? jsondecode(file("./config.json")) : {}

#Now using the jsondecode function, First we check if the file exists or not
If it exists then use jsondecode to read the file and send blank response.



