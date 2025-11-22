#VPC Output

output "vpc_id" {
  value = aws_vpc.VPC.id
}


#Control Subnet Output

output "Control_subnet_id" {
  value = aws_subnet.Control.id
}

output "Control_Subnet_Prefix" {
  value = "${var.net_prefix}.10"
}

#Managed Subnet1 Outputs

output "Managed_subnet1_id" {
  value = aws_subnet.Managed1.id
}

output "Managed_Subnet1_Prefix" {
  value = "${var.net_prefix}.50"
}

#Managed Subnet2 Outputs

output "Managed_subnet2_id" {
  value = aws_subnet.Managed2.id
}

output "Managed_Subnet2_Prefix" {
  value = "${var.net_prefix}.60"
}


#SGs outputs
output "Managed_sg_id" {
  value = aws_security_group.Managed_SG.id
}


output "Control_sg_id" {
  value = aws_security_group.Control_SG.id
}
