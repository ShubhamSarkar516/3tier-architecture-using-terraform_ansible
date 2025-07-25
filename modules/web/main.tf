resource "aws_instance" "web_server" {
  count         = length(var.subnet_ids)
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_ids[count.index]
  vpc_security_group_ids = [var.vpc_sg_id]
  key_name      = var.key_name

  tags = {
    Name = "Web-Server-${count.index + 1}"
  }

  provisioner "local-exec" {
    command = <<EOT
      echo [webserver] >> ${path.root}/ansible/hosts.ini && \
      echo ${self.private_ip} ansible_user=ubuntu ansible_ssh_private_key_file=../Mafia ansible_ssh_common_args="'-o StrictHostKeyChecking=no'" >> ${path.root}/ansible/hosts.ini
    EOT
  }
}

# ALB Target Group Attachments
resource "aws_lb_target_group_attachment" "web_instance_attachment" {
  count            = length(aws_instance.web_server)
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.web_server[count.index].id
  port             = 80
}

