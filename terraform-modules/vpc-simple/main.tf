// VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  tags = {
    "Name" = "tg"
  }
}

// Public Subnet
resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidr
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "tf-1a-public"
  }
}

// Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw"
  }
}

// Route table for public subnet
// route traffic to internet gateway
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "pub-route"
  }
}

// Set main route is  public route
resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.rtb.id
}

// Associate subnet to route
resource "aws_route_table_association" "rtb1a" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rtb.id
}


