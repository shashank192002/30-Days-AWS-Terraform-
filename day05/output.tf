#Output variable
output "s3_id" {
  value = aws_s3_bucket.first_bucket.id
}


#Output variable
output "ec2_id" {
  value = aws_instance.ec2.id
}