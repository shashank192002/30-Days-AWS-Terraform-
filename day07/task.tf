resource "aws_s3_bucket" "name" {
  for_each = var.bucknames

  bucket = each.key
}



variable "bucknames" {
  type = set(string)

  default = [ "valimaginary-girlfriend-bucket123","imaginary-girlfriend-bucket1234","imaginary-girlfriend-bucket12345" ]
}

output "bucket_names" {
  value = [for b in aws_s3_bucket.name: b.bucket]
  description = "A list of all S3 bucket names"
}

output "bucket_ids" {
  value = [for b in aws_aws_s3_bucket.name: b.id]
  description = "A list of all S3 bucket ID's"
}