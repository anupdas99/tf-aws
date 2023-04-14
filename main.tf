
# Create a VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "example-vpc"
  }
}

# Create a Subnet
resource "aws_subnet" "example_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "example-subnet"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id

  tags = {
    Name = "example-igw"
  }
}

# Create a Route Table
resource "aws_route_table" "example_rt" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }

  tags = {
    Name = "example-rt"
  }
}

# Create a Security Group
resource "aws_security_group" "example_sg" {
  name_prefix = "example-sg-"
  vpc_id = aws_vpc.example_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
    Name = "example-sg"
  }
}

# create key pair

resource "tls_private_key" "example_keypair" {
  algorithm = "RSA"
  rsa_bits = 2048
}

# create key pair

resource "aws_key_pair" "example_keypair" {
  key_name = "example_keypair"
  public_key = tls_private_key.example_keypair.public_key_openssh
}

# create pem file

resource "local_file" "example_keypair_file" {
  content  = tls_private_key.example_keypair.private_key_pem
  filename = "example_keypair.pem"
  file_permission = "0600"
}

# Launch an EC2 instance
resource "aws_instance" "example_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = "example_keypair"
  subnet_id     = aws_subnet.example_subnet.id
  vpc_security_group_ids = [aws_security_group.example_sg.id]

  # Attach an Elastic IP Address to the instance
  associate_public_ip_address = true

  # Use the userdata script to install Apache web server
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF

  tags = {
    Name = "example-instance"
  }
}
