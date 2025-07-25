output "web_instance_ids" {
  description = "IDs of all web server instances across AZs"
  value       = [for instance in aws_instance.web_server : instance.id]
}

output "web_instance_private_ips" {
  description = "Private IPs of web servers"
  value       = [for instance in aws_instance.web_server : instance.private_ip]
}

output "web_instance_public_ips" {
  description = "Public IPs of web servers (if assigned)"
  value       = [for instance in aws_instance.web_server : instance.public_ip]
}

