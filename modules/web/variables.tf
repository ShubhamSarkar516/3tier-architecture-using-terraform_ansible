variable "ami_id" {
  description = "AMI ID for the web servers"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_ids" {
  description = "List of public subnet IDs for AZ1 and AZ2"
  type        = list(string)
}

variable "vpc_sg_id" {
  description = "Security Group ID for the web servers"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "target_group_arn" {
  description = "Target Group ARN for ALB attachment"
  type        = string
}
