# VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "custom-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "my-igw"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "nat-eip"
  }
}

# Public Subnets (Web Tier) across 2 AZs
resource "aws_subnet" "websubnet" {
  count                   = 2
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = var.web_cidr_blocks[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "web-subnet-${count.index}"
  }
}

# Private Subnets (App Tier)
resource "aws_subnet" "appsubnet" {
  count             = 2
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = var.app_cidr_blocks[count.index]
  availability_zone = var.azs[count.index]
  tags = {
    Name = "app-subnet-${count.index}"
  }
}

# DB Subnets
resource "aws_subnet" "dbsubnet" {
  count             = 2
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = var.db_cidr_blocks[count.index]
  availability_zone = var.azs[count.index]
  tags = {
    Name = "db-subnet-${count.index}"
  }
}

# ALB Subnets (reuse websubnets or dedicated)
resource "aws_subnet" "albsubnet" {
  count                   = 2
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = var.alb_cidr_blocks[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "alb-subnet-${count.index}"
  }
}

# NAT Gateway in first public subnet (1 AZ)
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.websubnet[0].id
  tags = {
    Name = "nat-gateway"
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }
  tags = {
    Name = "public-rt"
  }
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "private-rt"
  }
}

# Route table associations
resource "aws_route_table_association" "web_association" {
  count          = 2
  subnet_id      = aws_subnet.websubnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "app_association" {
  count          = 2
  subnet_id      = aws_subnet.appsubnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "db_association" {
  count          = 2
  subnet_id      = aws_subnet.dbsubnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "alb_association" {
  count          = 2
  subnet_id      = aws_subnet.albsubnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# RDS Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = aws_subnet.dbsubnet[*].id
  tags = {
    Name = "db-subnet-group"
  }
}

# ALB
resource "aws_lb" "internet_lb" {
  name               = "internet-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = aws_subnet.albsubnet[*].id
  tags = {
    Name = "internet-alb"
  }
}

# ALB Target Group
resource "aws_lb_target_group" "internet_tg" {
  name     = "internet-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.custom_vpc.id
  tags = {
    Name = "internet-tg"
  }
}

# ALB Listener
resource "aws_lb_listener" "internet_listener" {
  load_balancer_arn = aws_lb.internet_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internet_tg.arn
  }
}
