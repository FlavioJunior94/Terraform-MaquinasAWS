# Criação de uma nova VPC chamada "VPC-CLIENTE"
resource "aws_vpc" "CLIENTE_vpc" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "VPC-CLIENTE"
  }
}

# Criação de uma sub-rede dentro da nova VPC "VPC-CLIENTE"
resource "aws_subnet" "example_subnet" {
  vpc_id                  = aws_vpc.CLIENTE_vpc.id
  cidr_block              = "192.168.237.0/24"  # Bloco de IP para a sub-rede
  availability_zone       = "us-east-1a"  # Zona de disponibilidade
  map_public_ip_on_launch = true

  tags = {
    Name = "Sub-rede-CLIENTE01"
  }
}

# Criação de uma nova tabela de rotas associada à VPC
resource "aws_route_table" "CLIENTE_route_table" {
  vpc_id = aws_vpc.CLIENTE_vpc.id

  tags = {
    Name = "TableRoutes-CLIENTE01"
  }
}

# Associação da tabela de rotas à sub-rede
resource "aws_route_table_association" "CLIENTE_route_table_assoc" {
  subnet_id      = aws_subnet.example_subnet.id
  route_table_id = aws_route_table.CLIENTE_route_table.id
}
# Criação do Gateway da Internet
resource "aws_internet_gateway" "CLIENTE_igw" {
  vpc_id = aws_vpc.CLIENTE_vpc.id

  tags = {
    Name = "CLIENTE-IGW"
  }
}
# Atualização da tabela de rotas para usar o Gateway da Internet
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.CLIENTE_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.CLIENTE_igw.id
}

