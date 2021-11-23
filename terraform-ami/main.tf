provider "aws" {
  region = "sa-east-1"
}

locals {
  date = "${formatdate("hhmmss", timestamp())}"
}


resource "aws_ami_from_instance" "ami-jenkins" {
  name               = "ortaleb-terraform-jenkins-${var.versao}-${local.date}"
  source_instance_id = var.resource_id
  tags = {
    Owner = "grupo-one"
  }
}



variable "resource_id" {
  type        = string
  description = "Qual o ID da máquina?"
}

variable "versao" {
  type        = string
  description = "Qual versão da imagem?"
}

output "ami" {
  value = [
    "AMI: ${aws_ami_from_instance.ami-jenkins.id}"
  ]
}
