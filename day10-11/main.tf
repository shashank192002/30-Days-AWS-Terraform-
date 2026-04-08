locals {
  formatted_proj_name = lower(replace(var.project_name," ","-"))
  new_tag = merge(var.default_tags,var.environment_tags)

  formatted_bucket_name = replace(replace(
   substr(lower(var.bucket_name),0,63),
   " ",""
   
  ),"!","")


  port_list = split(",",var.allowed_ports)

  sg_rules = [ for port in local.port_list:

  {
    name = "port-${port}"
    port = port
    description = "Allow traffic on port ${port}"
  }

  ]

  instance_size = lookup(var.instances_size,var.environment,"t2.micro")


  all_location = toset(concat(var.user_locations,var.default_locations))

  #unique_locations = toset(local.all_location)

  positive_cost = [for cost in var.monthly_costs: abs(cost) ]

  

  max_cost =  max(local.positive_cost...)

  min_cost = min(local.positive_cost...) 

  total_cost = sum(local.positive_cost) 

  avg_cost = local.total_cost / length(local.positive_cost)

  current_timestamp = timestamp()
  format1 = formatdate("yyyyMMdd",local.current_timestamp)
  format2 = "backup-${local.format1}"




  config_file_exists = fileexists("./config.json")
  config_data = local.config_file_exists ? jsondecode(file("./config.json")) : {}
}

resource "aws_s3_bucket" "s3" {
  bucket = local.formatted_bucket_name


  tags = local.new_tag

  
  
}

output "s3_bucket_tags" {
  value = aws_s3_bucket.s3.tags_all
}