output "instance_id" {
  value = aws_instance.ec2.id
}

output "Public_IP" {
  value = aws_instance.ec2.public_ip
}


output "Private_IP" {
  value = aws_instance.ec2.private_ip
}

