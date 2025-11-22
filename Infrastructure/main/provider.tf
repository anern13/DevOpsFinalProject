terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.100.0"
    }
  }
}


provider "aws" {
  alias       = "us-east-1"
  region      = "us-east-1"
  access_key  = var.aws_access_key_id
  secret_key  = var.aws_secret_access_key
  token       = var.aws_session_token
}

provider "aws" {
  alias       = "us-west-2"
  region      = "us-west-2"
  access_key  = var.aws_access_key_id
  secret_key  = var.aws_secret_access_key
  token       = var.aws_session_token
}
