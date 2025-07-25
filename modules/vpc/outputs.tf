output "vpc_id" {
  value = aws_vpc.custom_vpc.id
}

output "websubnet_ids" {
  value = [for s in aws_subnet.websubnet : s.id]
}

output "appsubnet_ids" {
  value = [for s in aws_subnet.appsubnet : s.id]
}

output "dbsubnet_ids" {
  value = [for s in aws_subnet.dbsubnet : s.id]
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.albsubnet : s.id]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.appsubnet[0].id,
    aws_subnet.dbsubnet[0].id
  ]
}

output "dbsubnet_group" {
  value = aws_db_subnet_group.db_subnet_group.name
}

output "alb_id" {
  value = aws_lb.internet_lb.id
}

output "target_group_arn" {
  value = aws_lb_target_group.internet_tg.arn
}

output "alb_dns_name" {
  value = aws_lb.internet_lb.dns_name
}

