variable "username" {
  description = "Master DB username"
  type = string
  default = "root"
}

variable "password" {
  description = "Master DB password"
  type = string
  sensitive   = true
  default = "Pass123456"
}

variable "dbsubnet_group" {
  description = "DB subnet group name"
  type        = string
}

variable "vpc_sg_id" {
  description = "Security Group ID to allow DB access (typically from app layer)"
  type        = string
}
