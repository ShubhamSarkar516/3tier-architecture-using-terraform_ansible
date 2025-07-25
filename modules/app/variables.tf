variable "ami_id" {
  description = "AMI ID for the App servers"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_ids" {
  description = "List of private subnet IDs for AZ1 and AZ2"
  type        = list(string)
}

variable "vpc_sg_id" {
  description = "Security group ID for App servers"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}
