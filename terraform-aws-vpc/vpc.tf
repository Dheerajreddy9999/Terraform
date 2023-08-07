
#create vpc
resource "aws_vpc" "vpc-demo" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "aws-prod-vpc"
  }
}

#create subnets
resource "aws_subnet" "us-east-2a-public" {
  vpc_id     = aws_vpc.vpc-demo.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "aws-prod-us-easet2a-public-subnet"
  }
}


resource "aws_subnet" "us-east-2b-public" {
  vpc_id     = aws_vpc.vpc-demo.id
  cidr_block = "10.0.32.0/20"
  availability_zone="us-east-2b"

  tags = {
    Name = "aws-prod-us-easet2b-public-subnet"
  }
}



#create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc-demo.id

  tags = {
    Name = "aws-prod-gw"
  }
}


#create route table for public subnet
resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.vpc-demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "aws-prod-public-route-table"
  }
}

#assciate route table to public subnet
resource "aws_route_table_association" "route-us-east-2a-public" {
  subnet_id      = aws_subnet.us-east-2a-public.id
  route_table_id = aws_route_table.public-route.id
}

resource "aws_route_table_association" "route-us-east-2b-public" {
  subnet_id      = aws_subnet.us-east-2b-public.id
  route_table_id = aws_route_table.public-route.id
}





