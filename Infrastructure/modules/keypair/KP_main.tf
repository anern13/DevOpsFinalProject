terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "aws_key_pair" "KP1" {
  key_name   = var.key_name
  public_key = tls_private_key.key.public_key_openssh
}

