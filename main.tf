provider "aws" {
  region = var.aws_region
}

#VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "flaskAppVPC"
    Terraform = "true"
  }
}

#SUBNET
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidr

  tags = {
    Name = "Public Subnet"
    Terraform = "true"
  }
}

#SG
resource "aws_security_group" "public_sg" {
  name = "Public security group"
  description = "Public internet access"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Security group for public subnet"
    Terraform = "true"
  }
}

resource "aws_security_group_rule" "public_out" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.public_sg.id
}

resource "aws_security_group_rule" "ssh_in"{
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.public_sg.id
}

resource "aws_security_group_rule" "http_in" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.public_sg.id
}

#Internet Gateway

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "IGW"
    Terraform = "true"
  }
}

#Route Tables

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id =aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "public route tables"
    Terraform = "true"
  }
}

resource "aws_route_table_association" "public" {
  depends_on = [aws_subnet.public_subnet]
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.public_subnet.id
}

  resource "aws_key_pair" "deployer" {
    key_name   = "flaskApp-key"
    public_key = file("~/.ssh/sarchype.pub")
  }

resource "aws_instance" "flaskServer" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = aws_key_pair.deployer.key_name
    associate_public_ip_address = true
    subnet_id = aws_subnet.public_subnet.id
    security_groups = [
    aws_security_group.public_sg.id
    ]
}
