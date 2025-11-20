# Create a VPC
resource "aws_vpc" "vp1" {
  cidr_block       = "172.120.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name        = "utc-app"
    Team        = "wdp"
    environment = "dev"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "gtw1" {
  vpc_id = aws_vpc.vp1.id
}

# Create public subnet 1
resource "aws_subnet" "public1" {
  availability_zone       = "us-east-1a"
  cidr_block              = "172.120.1.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.vp1.id
  tags = {
    Name = "utc-public-subnet-1a"
  }
}

# Create public subnet 2
resource "aws_subnet" "public2" {
  availability_zone       = "us-east-1b"
  cidr_block              = "172.120.2.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.vp1.id
  tags = {
    Name = "utc-public-subnet-1b"
  }
}

# Create private subnet 1
resource "aws_subnet" "private1" {
  availability_zone = "us-east-1a"
  cidr_block        = "172.120.3.0/24"
  vpc_id            = aws_vpc.vp1.id
  tags = {
    Name = "utc-private-subnet-1a"
  }
}

# Create private subnet 2
resource "aws_subnet" "private2" {
  availability_zone = "us-east-1b"
  cidr_block        = "172.120.4.0/24"
  vpc_id            = aws_vpc.vp1.id
  tags = {
    Name = "utc-private-subnet-1b"
  }
}

#Nat Gateway
resource "aws_eip" "el1" {
}

resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.el1.id
  subnet_id     = aws_subnet.public1.id
}

# Create a route table for public subnets
resource "aws_route_table" "rtpublic" {
  vpc_id = aws_vpc.vp1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gtw1.id
  }
}

# Create a route table for private subnets
resource "aws_route_table" "rtprivate" {
  vpc_id = aws_vpc.vp1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat1.id
  }
}

# Associate public 1 subnets with the route table
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.rtpublic.id
}

# Associate public 2 subnets with the route table
resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.rtpublic.id
}

# Associate private 1 subnets with the route table
resource "aws_route_table_association" "rta3" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.rtprivate.id
}

# Associate private 2 subnets with the route table
resource "aws_route_table_association" "rta4" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.rtprivate.id
}

