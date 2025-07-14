

output "private_key_pem" {
  value = aws_key_pair.generated.key_name
  description = "Private key to access AWS Resources in PEM Format."
  sensitive = true
}