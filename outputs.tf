# RDS DB Endpoint Output
output "rds_endpoint" {
  value       = module.db.db_endpoint
  description = "RDS endpoint for database connection"
}

# Bastion Host Public IP (used for SSH access into private subnets)
output "bastion_public_ip" {
  value       = module.bastion.bastion_public_ip
  description = "Public IP of the Bastion host"
}

# ALB DNS Name (for accessing web tier via browser)
output "alb_dns_name" {
  value       = module.vpc.alb_dns_name
  description = "Public DNS of Application Load Balancer"
}

# Web EC2 Instances (in both AZs)
output "web_instance_ids" {
  value       = module.web.web_instance_ids
  description = "List of Web tier EC2 instance IDs across 2 AZs"
}

# App EC2 Instances (in both AZs)
output "app_instance_ids" {
  value       = module.app.app_instance_ids
  description = "List of App tier EC2 instance IDs across 2 AZs"
}

# ALB Target Group ARN
output "target_group_arn" {
  value       = module.vpc.target_group_arn
  description = "Target Group ARN for ALB to attach instances"
}
