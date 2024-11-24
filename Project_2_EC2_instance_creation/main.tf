provider "aws" {
  region = "ap-south-1"
}
variable "cidr" {
  default = "10.0.0.0/16"
}
resource "aws_vpc" "MyVpc" {
  cidr_block = var.cidr
  tags = {
    Name = "MyVpc"
  }
}
resource "aws_subnet" "Mysub1" {
  vpc_id = aws_vpc.MyVpc.id
  availability_zone = "ap-south-1a"
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name="Mysub1"
  }
}
resource "aws_subnet" "Mysub2" {
  vpc_id = aws_vpc.MyVpc.id
  availability_zone = "ap-south-1b"
  cidr_block = "10.0.1.0/24"
  tags = {
    Name="Mysub2"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.MyVpc.id
  tags = {
    Name="MyIgw"
  }
}
resource "aws_route_table" "MyRT" {
  vpc_id = aws_vpc.MyVpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name="MyRT"
  }
}
resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.Mysub1.id
  route_table_id = aws_route_table.MyRT.id
}
resource "aws_route_table_association" "rta2" {
  subnet_id = aws_subnet.Mysub2.id
  route_table_id = aws_route_table.MyRT.id
}
resource "aws_instance" "MyEc2" {
  ami = "ami-0aebec83a182ea7ea"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.Mysub1.id
  tags = {
    Name="MyEc2"
  }
}