provider "aws" {
  profile = "chave terraform"
  region  = "us-east-1"
}

# Gerar de um par de chaves SSH
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Criar de um par de chaves EC2 na AWS usando a chave pública gerada
resource "aws_key_pair" "example" {
  key_name   = "CLIENTE_key"
  public_key = tls_private_key.example.public_key_openssh
}

# Criação de múltiplos grupos de segurança, um para cada instância EC2
resource "aws_security_group" "ec2_sg" {
  count = 3
  vpc_id = aws_vpc.CLIENTE_vpc.id

  name = format("EC2-SG-%02d", count.index + 1)  # Nome único para cada SG

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["201.162.72.136/32"]  # Acesso SSH permitido apenas para este IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Saída permitida para internet
  }

  tags = {
    Name = format("EC2-SG-%02d", count.index + 1)  # Nome único para cada SG
  }
}

# Criação de múltiplas instâncias EC2 com o par de chaves gerado
resource "aws_instance" "example" {
  count         = 3
  ami           = "ami-03f566666c90f05a7"
  instance_type = "t2.micro"
  
  # Associação com o par de chaves SSH
  key_name = aws_key_pair.example.key_name

  # Associação de cada instância com seu próprio Security Group
  subnet_id              = aws_subnet.example_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg[count.index].id]

  tags = {
    Name = format("EC2-Teste-%02d", count.index + 1)  # Nome único para cada instância
  }
}

# Saída da chave privada para acesso SSH
output "private_key_pem" {
  description = "A chave privada para acessar as instâncias EC2"
  value       = tls_private_key.example.private_key_pem

  sensitive = true  # Marcar como sensível para proteger a chave privada
}
