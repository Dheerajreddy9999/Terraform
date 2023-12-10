output "public-ip-address" {
    value = aws_instance.web.public_ip
}