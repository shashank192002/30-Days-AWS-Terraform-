output "project_name_new" {
  value = local.formatted_proj_name
}

output "port_list" {
  value = local.port_list
}
output "sg_rules" {
  value = local.sg_rules
}

output "instance_size" {
  value = local.instance_size
}

output "credentials" {
  value = var.credentials
  sensitive = true
}

output "all_location" {
  value = local.all_location
}

/*output "unique_locations" {
  value = local.unique_locations
}*/

output "positive_cost" {
  value = local.positive_cost
}

output "avg_cost" {
  value = local.avg_cost
}

output "total_cost" {
  value = local.total_cost
}

output "min_cost" {
  value = local.min_cost
}

output "timeva" {
  value = local.current_timestamp
}

output "config_data" {
  value = local.config_data
}