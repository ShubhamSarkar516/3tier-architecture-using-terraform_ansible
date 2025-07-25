# AWS Region
variable "myregion" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# AMI ID
variable "ami_id" {
  description = "AMI ID for EC2 instances (Ubuntu preferred)"
  type        = string
}

# EC2 Instance Type
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

# RDS Username
variable "username" {
  description = "Username for RDS"
  type        = string
  sensitive   = true
}

# RDS Password
variable "password" {
  description = "Password for RDS"
  type        = string
  sensitive   = true
}

# SSH Key Pair Name
variable "key_name" {
  description = "SSH key pair name for EC2 access"
  type        = string
}

# Availability Zones for High Availability
variable "azs" {
  description = "List of availability zones to deploy resources in"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# VPC CIDR
variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Subnet CIDR blocks per tier
variable "web_cidr_blocks" {
  description = "List of CIDR blocks for Web subnets (2 AZs)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "app_cidr_blocks" {
  description = "List of CIDR blocks for App subnets (2 AZs)"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "db_cidr_blocks" {
  description = "List of CIDR blocks for DB subnets (2 AZs)"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}

# Optional: ALB subnet CIDRs if you're using public subnets
variable "alb_cidr_blocks" {
  description = "CIDRs for ALB public subnets (optional)"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

