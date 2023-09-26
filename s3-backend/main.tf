provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "dheeraj-server" {
  ami = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
}

resource "aws_s3_bucket" "s3-bucket" {
  bucket = "dheeraj-terraform-s3-lock-useast-1"
}

resource "aws_dynamodb_table" "terraform-lock" {
  name = "terraform-s3-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

}
