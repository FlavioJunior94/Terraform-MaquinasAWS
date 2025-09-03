provider "aws" {
  region = "us-east-1"
}

# Cria uma VPC personalizada
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "example-vpc"
  }
}

# Cria uma subnet pública na VPC
resource "aws_subnet" "example_subnet" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

# Cria um Security Group para a VPC
resource "aws_security_group" "example_sg" {
  vpc_id = aws_vpc.example_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permite SSH de qualquer IP
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

# Cria a instância EC2 associada à VPC e Subnet
resource "aws_instance" "free_tier_instance" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type = "t2.micro"

  # Associar a Subnet e o Security Group
  subnet_id              = aws_subnet.example_subnet.id
  vpc_security_group_ids = [aws_security_group.example_sg.id]

  tags = {
    Name = "simple-free-tier-instance"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "root:YourPassword123" | chpasswd
              EOF

  key_name = aws_key_pair.generated_key_pair.key_name
}

# Cria o par de chaves
resource "aws_key_pair" "generated_key_pair" {
  key_name   = "example-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Output do IP público da instância
output "instance_public_ip" {
  value = aws_instance.free_tier_instance.public_ip
}
