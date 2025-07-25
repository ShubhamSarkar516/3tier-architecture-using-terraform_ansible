variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "web_cidr_blocks" {
  description = "List of CIDR blocks for web subnets (public) — 1 per AZ"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "app_cidr_blocks" {
  description = "List of CIDR blocks for app subnets (private) — 1 per AZ"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "db_cidr_blocks" {
  description = "List of CIDR blocks for database subnets (private) — 1 per AZ"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "alb_cidr_blocks" {
  description = "List of CIDR blocks for ALB subnets (public) — 1 per AZ"
  type        = list(string)
  default     = ["10.0.31.0/24", "10.0.32.0/24"]
}

variable "alb_sg_id" {
  description = "Security Group ID for the Application Load Balancer"
  type        = string
}
