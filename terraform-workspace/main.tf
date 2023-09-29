provider "aws" {
  region = "us-east-2"
}

variable "ami" {
  description = "AMI for the instance"
}

variable "instance_type" {
  description = "isntance type "
  type = map(string)

  default = {
    "dev" = "t2.nano"
    "stage" = "t2.micro"
    "prod" = "t2.small"
  }
}

module "ec2_isntance" {
  source = "./modules/ec2"
  ami = var.ami
  isntance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
}
