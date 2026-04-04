#Count example
resource "aws_s3_bucket" "name" {
  count = 2			#create a count of 2 for 2 values

  bucket = var.bucket_name[count.index]		#Iterate using count.index
  tags = var.tags
}


#for_each example
variable "bucket_name_set" {
  type = set(string)
  default = ["my-unquie-bucket-day08-1234560","my-unquie-bucket-day08-1234569"]
}


resource "aws_s3_bucket" "bucket2" {
  for_each = var.bucket_name_set    #2

  bucket = each.key
}


#depends_on example
resource "aws_s3_bucket" "bucket1" {
  count = length(var.bucket_name)

  bucket = var.bucket_name[count.index]
 tags = var.tags
}


resource "aws_s3_bucket" "bucket2" {
  for_each = var.bucket_name_set    #2

  bucket = each.value

  depends_on = [ aws_s3_bucket.bucket1 ]	#Mention resource name of dependents
}



#for expression example

output "bucket_names" {
  value = [for b in aws_s3_bucket.name: b.bucket]
  description = "A list of all S3 bucket names"
}

output "bucket_ids" {
  value = [for b in aws_aws_s3_bucket.name: b.id]
  description = "A list of all S3 bucket ID's"
}