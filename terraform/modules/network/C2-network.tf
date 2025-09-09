resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  
  tags = {
    Name = var.vpc_name
    env = var.env
  }
}
resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 4, 1)
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone = var.subnet_az
  tags = {
    Name = "${var.vpc_name}-subnet"
    env = var.env
    vpc_name = var.vpc_name
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Associate
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "rt-pub"
    env = var.env
    vpc_name = var.vpc_name
  }
}
resource "aws_route_table_association" "route_table_association" {
  route_table_id = aws_route_table.route_table.id
  subnet_id = aws_subnet.subnet.id
  
}