# db-instance -rds

resource "aws_db_instance" "rds" {
  allocated_storage       = 10
  db_name                 = "mydb"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                = var.username
  password                = var.password
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true
  db_subnet_group_name    = var.dbsubnet_group
  vpc_security_group_ids  = [var.vpc_sg_id]
  multi_az                = true

  tags = {
    Name = "3Tier-RDS-MySQL"
  }
}
