output "db_endpoint" {
  description = "RDS endpoint to connect from app"
  value       = aws_db_instance.rds.endpoint
}

