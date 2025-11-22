variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "aws_session_token" {}
variable "ec2_image_id_public" {}
variable "ec2_image_id_apps" {}
variable "instance_type" {}
variable "source_ip" {}


locals {
  ansible_install_user_data = file("${path.module}/../ansible/user_data.sh")
}
