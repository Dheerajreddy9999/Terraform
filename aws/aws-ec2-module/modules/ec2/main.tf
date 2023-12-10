resource "aws_instance" "web" {
  ami           = var.ami_value
  instance_type = var.instance_type_value
  key_name      = var.key_pair_name

  tags = {
    Name = "web-server"
  }
}