variable "ami" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "type" {
  description = "The EC2 instance type (e.g., t3.micro)"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to launch the instance into"
  type        = string
}

variable "sg_id" {
  description = "The security group ID to attach to the instance"
  type        = string
}

variable "key_name" {
  description = "The name of the EC2 key pair to use for SSH access"
  type        = string
}


variable "EC2_Name" {
  description = "The name of the EC2 Instance"
  type        = string
}

variable "private_ip" {
  description = "The private IP for the EC2 instance"
  type        = string
}

variable "user_data" {
  description = "User data script"
  type        = string
  default     = ""
}