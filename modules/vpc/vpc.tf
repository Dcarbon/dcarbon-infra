resource "aws_vpc" "main-vpc" {
  cidr_block = var.CIDR_BLOCK
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"

  tags = merge({
    Name = "main-vpc"
  }, var.TAGS)
}

resource "aws_subnet" "main-public-1" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.CIDR_BLOCK_PUBLIC_SUBNET_1
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.AWS_REGION}a"

  tags = {
    Name = "main-public-1"
  }
}

resource "aws_subnet" "main-public-2" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.CIDR_BLOCK_PUBLIC_SUBNET_2
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.AWS_REGION}b"

  tags = {
    Name = "main-public-2"
  }
}

resource "aws_subnet" "main-private-1" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.CIDR_BLOCK_PRIVATE_SUBNET_1
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.AWS_REGION}a"

  tags = {
    Name = "main-private-1"
  }
}

resource "aws_subnet" "main-private-2" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.CIDR_BLOCK_PRIVATE_SUBNET_2
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.AWS_REGION}b"

  tags = {
    Name = "main-private-2"
  }
}

# Internet GW
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "main-igw"
  }
}

# resource "aws_nat_gateway" "main-ngw" {
#   allocation_id = var.ALLOCATION_ID
#   subnet_id     = aws_subnet.main-public-1.id
# }

# route tables
resource "aws_route_table" "main-public-rtb" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }

  tags = {
    Name = "main-public-rtb"
  }
}

resource "aws_route_table" "main-private-rtb" {
  vpc_id = aws_vpc.main-vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.main-ngw.id
#   }
  tags = {
    Name = "main-private-rtb"
  }
}

# route associations public
resource "aws_route_table_association" "main-public-1-a" {
  subnet_id      = aws_subnet.main-public-1.id
  route_table_id = aws_route_table.main-public-rtb.id
}

resource "aws_route_table_association" "main-public-2-a" {
  subnet_id      = aws_subnet.main-public-2.id
  route_table_id = aws_route_table.main-public-rtb.id
}

# route associations private
resource "aws_route_table_association" "main-private-1-a" {
  subnet_id      = aws_subnet.main-private-1.id
  route_table_id = aws_route_table.main-private-rtb.id
}

resource "aws_route_table_association" "main-private-2-a" {
  subnet_id      = aws_subnet.main-private-2.id
  route_table_id = aws_route_table.main-private-rtb.id
}