resource "aws_key_pair" "example" {
  key_name = "Terraform_project_key_pair-demo"
  public_key = file("~/.ssh/id_rsa.pub")
}
resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr
}
resource "aws_subnet" "subnet_1" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
}
resource "aws_route_table" "RT" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block="0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    } 
}
resource "aws_route_table_association" "RTA" {
  route_table_id = aws_route_table.RT.id
  subnet_id = aws_subnet.subnet_1.id
}
resource "aws_security_group" "WEBSG"{
    name = "WEBSG"
    vpc_id = aws_vpc.my_vpc.id
    ingress  {
        description="HTTP From Port 80"
        from_port = 80
        to_port=80
        protocol="tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
      ingress {
    description = "SSH"
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
  tags = {
    name="websg"
  }
}
resource "aws_instance" "Terraform_Ec2" {
  ami = var.AMI
  instance_type = var.instance_type
  key_name = aws_key_pair.example.key_name
  vpc_security_group_ids = [ aws_security_group.WEBSG.id ]
  subnet_id = aws_subnet.subnet_1.id
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host = self.public_ip
  }
}