provider "aws" {
  access_key = "AKIA3IEP6J2TQJE7HTG7"
  secret_key = "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"
  region = "us-east-1"
}
resource "aws_vpc" "terra1-vpc" {
    cidr_block = "172.31.3.0/24"
    enable_dns_support = true
    enable_dns_hostnames = true
    enable_classiclink = false
    instance_tenancy = "default"

    tags = {
      "Name" = "terra1-vpc"
    }
}
resource "aws_subnet" "terra1-subnet" {
    vpc_id = aws_vpc.terra1-vpc.id
    cidr_block = "172.31.3.0/28"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"

    tags = {
      "Name" = "terra1-subnet"
    }
}
resource "aws_internet_gateway" "terra1-gw" {
    vpc_id = aws_vpc.terra1-vpc.id

    tags = {
      "Name" = "terra1-gw"
    }
}
resource "aws_route_table" "terra1-rt" {
    vpc_id = aws_vpc.terra1-vpc.id
    route {
        cidr_block = "0.0.0.0/0" 
        gateway_id = aws_internet_gateway.terra1-gw.id
    }
    tags = {
      "Name" = "terra1-rt"
    }
}
resource "aws_route_table_association" "terra1-rta" {
    subnet_id = aws_subnet.terra1-subnet.id
    route_table_id = aws_route_table.terra1-rt.id
}
resource "aws_security_group" "terra1-sg" {
    vpc_id = aws_vpc.terra1-vpc.id
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      "Name" = "terra1-sg"
    }
}
resource "aws_instance" "testubunta2" {
    ami = "ami-09e67e426f25ce0d7"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.terra1-subnet.id
    vpc_security_group_ids = [aws_security_group.terra1-sg.id]
    key_name = "shtirliz"
    user_data = file("1.sh")

    tags = {
      "Name" = "terra1-ubunta1"
    }
}
