#bastion_server_instance
resource "aws_instance" "bastion_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.vpc_sg_id]
  key_name = "Mafia"
  tags = {
    Name = "Bastion_Server"
  }
}

