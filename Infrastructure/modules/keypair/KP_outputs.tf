
output "private_key_pem" {
  description = "The generated private key in PEM format"
  value       = tls_private_key.key.private_key_pem
  sensitive   = true
}

output "key_name" {
  value = var.key_name
}