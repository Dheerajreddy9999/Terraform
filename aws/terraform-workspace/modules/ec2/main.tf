provider "aws" {
    region = "us-east-2"
}

variable "ami" {
  description = "AMI for the instance"
}

variable "isntance_type" {
  description = "isntance type (like t2.micro)"
}


resource "aws_instance" "example" {
  ami = var.ami
  instance_type = var.isntance_type
}