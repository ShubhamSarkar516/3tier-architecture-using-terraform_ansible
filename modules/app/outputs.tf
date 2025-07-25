output "app_instance_ids" {
  description = "IDs of all app server instances across AZs"
  value       = [for instance in aws_instance.app_server : instance.id]
}

output "app_instance_private_ips" {
  description = "Private IPs of app servers"
  value       = [for instance in aws_instance.app_server : instance.private_ip]
}
