output "public_vm_ip" {
  value = module.EC2_Control.Public_IP
}

output "private_apps201" {
  value = module.ec2_apps[0].Private_IP
}

output "private_apps202" {
  value = module.ec2_apps[1].Private_IP
}

output "private_apps203" {
  value = module.ec2_apps[2].Private_IP
}

output "alb_dns_name" {
  value = aws_lb.web_alb.dns_name
}

output "alb_arn" {
  value = aws_lb.web_alb.arn
}


