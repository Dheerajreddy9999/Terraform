provider "aws" {
    region = "us-east-1"
}

module "ec2_instance" {
    source = "./modules/ec2"
    ami_value = "ami-024e6efaf93d85776"
    instance_type_value = "t2.micro"
    key_pair_name = "dheeraj" 
}