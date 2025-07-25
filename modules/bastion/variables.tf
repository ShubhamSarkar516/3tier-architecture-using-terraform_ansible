variable "ami_id" {
  description = "AMI ID for Bastion Host (Ubuntu recommended)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for Bastion Host"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Public subnet ID where the Bastion Host should be launched"
  type        = string
}

variable "vpc_sg_id" {
  description = "Security group ID for Bastion Host"
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
}
