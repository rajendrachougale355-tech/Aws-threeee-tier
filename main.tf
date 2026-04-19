provider "aws" {
  region = "ap-south-1"   # Mumbai region
}

# -------------------------------
# VPC
# -------------------------------
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "three-tier-vpc"
  }
}

# -------------------------------
# Subnets
# -------------------------------
# Public subnet (for ALB + Nginx)
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

# Private subnet (for App servers)
resource "aws_subnet" "private_app_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "private-app-subnet"
  }
}

# Private subnet (for Database)
resource "aws_subnet" "private_db_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1c"
  tags = {
    Name = "private-db-subnet"
  }
}

# -------------------------------
# Internet Gateway
# -------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "three-tier-igw"
  }
}

# -------------------------------
# NAT Gateway (for private subnets)
# -------------------------------
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "three-tier-natgw"
  }
}
