provider "aws" {
  region = "sa-east-1"
}

locals {
  date = "${formatdate("hhmmss", timestamp())}"
}

resource "aws_instance" "dev_img_deploy_jenkins" {
  subnet_id     = "subnet-0958c1cc0f3c9b493"
  ami                         = "ami-0e66f5495b4efdd0f" #ubuntu
  instance_type = "t2.micro"
  key_name = "grupo-one"
  tags = {
    Name = "one-imgpadrao-ec2-k8s_${local.date}"
    Owner = "grupo-one"
  }
    associate_public_ip_address = true
    root_block_device {
    encrypted = true
    volume_size = 8
  }
  vpc_security_group_ids = [aws_security_group.acesso_jenkins_dev_img.id]
}

resource "aws_security_group" "acesso_jenkins_dev_img" {
  name        = "acesso_jenkins_dev_img_${local.date}"
  description = "acesso_jenkins_dev_img inbound traffic"
  vpc_id      = "vpc-063c0ac3627af3dba"

  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null,
      security_groups : null,
      self : null
    },
    {
      description      = "SSH from VPC"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null,
      security_groups : null,
      self : null
    },
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids  = null,
      security_groups : null,
      self : null,
      description : "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "jenkins-dev-img-lab"
    Owner = "gropo-one"
  }
}

# terraform refresh para mostrar o ssh
output "dev_img_deploy_jenkins" {
  value = [
    "resource_id: ${aws_instance.dev_img_deploy_jenkins.id}",
    "public_ip: ${aws_instance.dev_img_deploy_jenkins.public_ip}",
    "public_dns: ${aws_instance.dev_img_deploy_jenkins.public_dns}",
    "ssh -i /var/lib/jenkins/.ssh/grupo.one.pem ubuntu@${aws_instance.dev_img_deploy_jenkins.public_dns}"
  ]
}