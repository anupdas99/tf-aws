# Create a VPC
/*resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "example-vpc"
  }
}*/

# Create a Subnet
/*resource "aws_subnet" "example_subnet" {
  vpc_id     = var.vpc
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "example-subnet"
  }
}*/

# Create an Internet Gateway
/*resource "aws_internet_gateway" "example_igw" {
  vpc_id = var.vpc

  tags = {
    Name = "example-igw"
  }
}*/

# Create a Route Table
/*resource "aws_route_table" "example_rt" {
  vpc_id = var.vpc

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }

  tags = {
    Name = "example-rt"
  }
}*/

# Create a Security Group
resource "aws_security_group" "http" {
  name_prefix = "example-sg-"
  vpc_id      = var.vpc

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "http-sg"
  }
}

# create key pair

resource "tls_private_key" "my_keypair" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# create key pair

resource "aws_key_pair" "my_keypair" {
  key_name   = "my_keypair"
  public_key = tls_private_key.my_keypair.public_key_openssh
}

# create pem file

resource "local_file" "my_keypair" {
  content         = tls_private_key.my_keypair.private_key_pem
  filename        = "my_keypair.pem"
  file_permission = "0400"
}

# Launch an EC2 instance
resource "aws_instance" "http_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = "my_keypair"
  vpc_security_group_ids = [aws_security_group.http.id]

  # Attach an Elastic IP Address to the instance
  associate_public_ip_address = true

  # Use the userdata script to install Apache web server
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y apache2
              sudo service apache2 start
              sudo service apache2 status
              echo "<h1>Server-Name</h1><p>This is my HTTP server</p>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "web-instance"
  }
}
