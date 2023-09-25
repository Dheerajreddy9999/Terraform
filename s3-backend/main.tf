provider "aws" {
    region = "us-east-1"
}


resource "aws_instance" "dheeraj-server" {
  ami = "ami-024e6efaf93d85776"
  instance_type = "t2.micro"
}