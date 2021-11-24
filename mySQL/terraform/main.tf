
provider "aws" {
  region = "sa-east-1"
}

resource "aws_instance" "mysql_prod" {
  subnet_id     = "subnet-06ca18ecdcc48d784"
  ami           = "ami-0e66f5495b4efdd0f" #ubuntu
  instance_type = "t2.large"
  key_name      = "grupo-one"
  tags = {
    Name  = "one-ec2-mysql_prod"
    Owner = "grupo-one"
  }
  associate_public_ip_address = true
  root_block_device {
    encrypted   = true
    volume_size = 8
  }
  vpc_security_group_ids = [aws_security_group.acesso_mysql.id]
}


resource "aws_instance" "mysql_dev" {
  subnet_id     = "subnet-06ca18ecdcc48d784"
  ami           = "ami-0e66f5495b4efdd0f" #ubuntu
  instance_type = "t2.large"
  key_name      = "grupo-one"
  tags = {
    Name  = "one-ec2-mysql_dev"
    Owner = "grupo-one"
  }
  associate_public_ip_address = true
  root_block_device {
    encrypted   = true
    volume_size = 8
  }
  vpc_security_group_ids = [aws_security_group.acesso_mysql.id]
}


resource "aws_instance" "mysql_stage" {
  subnet_id     = "subnet-06ca18ecdcc48d784"
  ami           = "ami-0e66f5495b4efdd0f" #ubuntu
  instance_type = "t2.large"
  key_name      = "grupo-one"
  tags = {
    Name  = "one-ec2-mysql_stage"
    Owner = "grupo-one"
  }
  associate_public_ip_address = true
  root_block_device {
    encrypted   = true
    volume_size = 8
  }
  vpc_security_group_ids = [aws_security_group.acesso_mysql.id]
}



resource "aws_security_group" "acesso_mysql" {
  name        = "acesso_mysql"
  description = "acesso_mysql inbound traffic"
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
    Name  = "sg_mysql"
    Owner = "gropo-one"
  }
}


# terraform refresh para mostrar o DNS Publico
output "mysql_DNS_PROD" {
  value = [
    "mysql_prod: ${aws_instance.mysql_prod.public_dns}",

  ]
}

# terraform refresh para mostrar o DNS Publico
output "mysql_DNS_DEV" {
  value = [
    "mysql_dev: ${aws_instance.mysql_dev.public_dns}",

  ]
}

# terraform refresh para mostrar o DNS Publico
output "mysql_DNS_STAGE" {
  value = [
    "mysql_stage: ${aws_instance.mysql_stage.public_dns}",

  ]
}