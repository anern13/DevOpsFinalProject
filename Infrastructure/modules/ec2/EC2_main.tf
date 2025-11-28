terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}



resource "aws_instance" "ec2" {
  ami                    = var.ami
  instance_type          = var.type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  key_name               = var.key_name
  private_ip             = var.private_ip
  user_data              = var.user_data
  user_data_replace_on_change = true
  tags = {
    Name  =   var.EC2_Name
  }
}


