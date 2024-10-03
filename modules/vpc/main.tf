# terraform-modules/vpc/main.tf

provider "aws" {
  region = "eu-central-1"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-vpc"
  }
}

# Create Public Subnets
resource "aws_subnet" "public" {
  count = length(var.azs)
  
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

# Create Private Subnets
resource "aws_subnet" "private" {
  count = length(var.azs)
  
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.environment}-private-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-igw"
    Environment = var.environment
  }
}

# Create Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-public-route-table"
    Environment = var.environment
  }
}

# Create Route to Internet Gateway in Public Route Table
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Create NAT Gateway for Private Subnets
resource "aws_eip" "nat" {
  count = length(var.azs)
  domain = "vpc"

  tags = {
    Name = "${var.environment}-nat-eip-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.azs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.environment}-nat-gateway-${count.index + 1}"
    Environment = var.environment
  }
}

# Create Private Route Table for each AZ and associate with private subnets
resource "aws_route_table" "private" {
  count = length(var.azs)
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.environment}-private-route-table-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_route" "private_nat_gateway" {
  count                    = length(var.azs)
  route_table_id           = aws_route_table.private[count.index].id
  destination_cidr_block   = "0.0.0.0/0"
  nat_gateway_id           = aws_nat_gateway.nat[count.index].id
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

