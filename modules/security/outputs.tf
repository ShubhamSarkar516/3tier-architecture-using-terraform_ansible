output "alb_sg_id" {
  description = "Security Group ID for ALB"
  value = aws_security_group.alb_sg.id
}

output "web_sg_id" {
  description = "Security Group ID for Web Tier"
  value = aws_security_group.web_sg.id
}

output "app_sg_id" {
  description = "Security Group ID for App Tier"
  value = aws_security_group.app_sg.id
}

output "db_sg_id" {
  description = "Security Group ID for Database Tier"
  value = aws_security_group.db_sg.id
}

output "bastion_sg_id" {
  description = "Security Group ID for Bastion Host"
  value = aws_security_group.bastion_sg.id
}
