variable "vpc_name" {
  description = "The name to assign to the VPC and its resources"
  type        = string
}

variable "net_prefix" {
  description = "Network prefix for CIDR blocks (e.g., 10.10)"
  type        = string
}


variable "Control_Subnet_AZ" {
  description = "AZ for the Control subnet"
  type        = string
}

variable "Managed_Subnet1_AZ" {
  description = "AZ for the Managed subnet"
  type        = string
}

variable "Managed_Subnet2_AZ" {
  description = "AZ for the Managed subnet"
  type        = string
}


variable "source_ip" {
  description = "Source IP allowed to SSH"
  type        = string
}


