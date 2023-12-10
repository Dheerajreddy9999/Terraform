provider "aws" {
  region = "us-east-2"
}


variable "cidr" {
  default = "10.0.0.0/16"
}


resource "aws_key_pair" "deployer" {
  key_name   = "dheeraj-key"
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr

  tags = {
    Name = "provisioner-demo"
  }
}

resource "aws_subnet" "us-east-2a-subnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "RT" {
    vpc_id = aws_vpc.myvpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "rt1" {
    subnet_id = aws_subnet.us-east-2a-subnet.id
    route_table_id = aws_route_table.RT.id
}


resource "aws_security_group" "webSg" {
  name        = "web"
  description = "Allow port 22 and 80"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "Allow HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
    ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-Sg"
  }
}

resource "aws_instance" "web-demo" {
  ami = "ami-024e6efaf93d85776"
  instance_type = "t2.micro"
  key_name = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [ aws_security_group.webSg.id ]
  subnet_id = aws_subnet.us-east-2a-subnet.id

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host = self.public_ip
  }

  provisioner "file" {
    source      = "app.py"
    destination = "/home/ubuntu/app.py"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello rom remote instance'",
      "sudo apt update",
      "sudo apt install -y python3-pip",
      "cd /home/ubuntu",
      "sudo pip3 install flask",
      "sudo python3 app.py &",
    ]
  }
}

output "instance_public_ip" {
  value = aws_instance.web-demo.public_ip
  
}
