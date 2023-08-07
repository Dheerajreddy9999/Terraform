terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 0.12"
  
}

#create bastion server to connect with instances located in private subnet
resource "aws_instance" "web" {
  ami           = "ami-024e6efaf93d85776"
  instance_type = "t2.micro"
  key_name      = "dheeraj"
  subnet_id     = aws_subnet.us-east-2b-public.id

  tags = {
    Name = "bastion"
  }
}


# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}

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


resource "aws_subnet" "us-east-2a-private" {
  vpc_id     = aws_vpc.vpc-demo.id
  cidr_block = "10.0.16.0/20"
  availability_zone="us-east-2a"

  tags = {
    Name = "aws-prod-us-easet2a-private-subnet"
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


resource "aws_subnet" "us-east-2b-private" {
  vpc_id     = aws_vpc.vpc-demo.id
  cidr_block = "10.0.64.0/24"
  availability_zone="us-east-2b"

  tags = {
    Name = "aws-prod-us-easet2b-private-subnet"
  }
}

#create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc-demo.id

  tags = {
    Name = "aws-prod-gw"
  }
}


#create nat gateways
resource "aws_nat_gateway" "nat-gateway-2a" {
  connectivity_type = "private"
  subnet_id     = aws_subnet.us-east-2a-private.id

  tags = {
    Name = "nat-gateway-us-east-2a"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}


resource "aws_nat_gateway" "nat-gateway-2b" {
  connectivity_type = "private"
  subnet_id     = aws_subnet.us-east-2b-private.id

  tags = {
    Name = "nat-gateway-us-east-2b"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
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


#create route table for private subnet 2a
resource "aws_route_table" "private-route-2a" {
  vpc_id = aws_vpc.vpc-demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gateway-2a.id
  }

  tags = {
    Name = "aws-prod-private-route-table-2a"
  }
}


resource "aws_route_table_association" "route-us-east-2a-private" {
  subnet_id      = aws_subnet.us-east-2a-private.id
  route_table_id = aws_route_table.private-route-2a.id
}



#create  route table for private subnet 2b
resource "aws_route_table" "private-route-2b" {
  vpc_id = aws_vpc.vpc-demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gateway-2b.id
  }

  tags = {
    Name = "aws-prod-private-route-table-2b"
  }
}


resource "aws_route_table_association" "route-us-east-2b-private" {
  subnet_id      = aws_subnet.us-east-2b-private.id
  route_table_id = aws_route_table.private-route-2b.id
}



#create security group
resource "aws_security_group" "default-sg" {
  name   = "aws-prod-sg"
  vpc_id = aws_vpc.vpc-demo.id

  ingress {
    description = "Allow web traffic"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
 }
}



#create launch template
resource "aws_launch_template" "webserver-template" {
  image_id      = "ami-024e6efaf93d85776"
  instance_type = "t2.micro"
  key_name = "dheeraj"

  network_interfaces {
    security_groups = [ aws_security_group.default-sg.id ]
  }

  tags = {
    name = "prod-aws-template"
  }
}


#create autoscaling group
resource "aws_autoscaling_group" "webserver-asg" {
  name                      = "prod-aws-asg"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 2
  vpc_zone_identifier       = [aws_subnet.us-east-2a-private.id, aws_subnet.us-east-2b-private.id]
  target_group_arns         = [aws_lb_target_group.webserver-target-group.id]
   
  launch_template {
    id      = aws_launch_template.webserver-template.id
    version = "$Latest"
  }

}


#create target group for load balancer
resource "aws_lb_target_group" "webserver-target-group" {
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc-demo.id

  tags ={
    name = "prod-target-group"
  }
}


#create load balcner resource
resource "aws_lb" "alb" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.default-sg.id]
  subnets            = [aws_subnet.us-east-2a-public.id, aws_subnet.us-east-2b-public.id]  
  
  tags ={
    name = "prod-aws-alb"
  }
}


#Associate target group with load balancer
resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 8000  
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver-target-group.arn
  }
}





