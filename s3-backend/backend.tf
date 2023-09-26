terraform {
  backend "s3" {
    bucket = "dheeraj-terraform-s3-lock-useast-1"
    key = "dheeraj/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    dynamodb_table = "terraform-lock"
    
  }
}