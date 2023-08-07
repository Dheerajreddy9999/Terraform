terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 0.12"
  
}

resource "aws_instance" "web" {
  ami           = "ami-024e6efaf93d85776"
  instance_type = "t2.micro"
  key_name      = "dheeraj"

  tags = {
    Name = "web-server"
  }
}