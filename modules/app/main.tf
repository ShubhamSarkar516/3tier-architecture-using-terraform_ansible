resource "aws_instance" "app_server" {
  count         = length(var.subnet_ids)
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_ids[count.index]
  vpc_security_group_ids = [var.vpc_sg_id]
  key_name      = var.key_name

  tags = {
    Name = "App-Server-${count.index + 1}"
  }

  provisioner "local-exec" {
    command = <<EOT
      echo [appserver] >> ${path.root}/ansible/hosts.ini && \
      echo ${self.private_ip} ansible_user=ubuntu ansible_ssh_private_key_file=../Mafia ansible_ssh_common_args="'-o StrictHostKeyChecking=no'" >> ${path.root}/ansible/hosts.ini
    EOT
  }
}
