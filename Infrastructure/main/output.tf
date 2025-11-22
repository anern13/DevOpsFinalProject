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


