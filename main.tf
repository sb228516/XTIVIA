# create vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

data "aws_subnets" "public_subnets" {}
data "aws_subnets" "private_subnets" {}

# create public subnet az1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnets[0]
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public-az1"
  }
}

# create public subnet az2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  =  aws_vpc.vpc.id
  cidr_block              = var.public_subnets[1]
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public-az2"
  }
}

# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id =  aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-public-rt"
  }
}

# associate public subnet az1 to "public route table"
resource "aws_route_table_association" "public_subnet_az1_rt_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

# associate public subnet az2 to "public route table"
resource "aws_route_table_association" "public_subnet_2_rt_association" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}

# create private  subnet az1
resource "aws_subnet" "private_subnet_az1" {
  vpc_id                  =  aws_vpc.vpc.id
  cidr_block              = var.private_subnets[0]
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-${var.environment}-private-az1"
  }
}

# create private subnet az2
resource "aws_subnet" "private_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnets[1]
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-${var.environment}-private-az2"
  }
}
  #create security group
   #security group with a rule allowing traffic from anywhere to port 443 for resources in the security group
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id
  name = var.https-security-group

  tags       = {
    Name     = "${var.project_name}-${var.environment}-security-group"
  }

  
  ingress {
    from_port   = var.to_https_port
    to_port     = var.to_https_port
    protocol    = var.sg_protocol
    cidr_blocks = ["0.0.0.0/0"]
  }
egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

  

resource "aws_eip" "elasticIP_one" {
  domain                    = "vpc"

}


resource "aws_eip" "elasticIP_two" {
  domain                    = "vpc"

}

resource "aws_nat_gateway" "nat_gateway_subnet1" {
  allocation_id = aws_eip.elasticIP_one.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  tags = {
    Name = "gw NAT one"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_nat_gateway" "nat_gateway_subnet2" {
  allocation_id = aws_eip.elasticIP_two.id
  subnet_id     = aws_subnet.public_subnet_az2.id

  tags = {
    Name = "gw NAT two"
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet_gateway]
}




  
# associate private subnet 1 with private route table 1
resource "aws_route_table" "private_route_table_1" {
  vpc_id =  aws_vpc.vpc.id

  route {
    cidr_block = var.private_subnets[0]
    gateway_id = aws_nat_gateway.nat_gateway_subnet1.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-private-rt-1"
  }
}


# associate private subnet 2 with private route table 2
resource "aws_route_table" "private_route_table_2" {
  vpc_id =  aws_vpc.vpc.id

  route {
    cidr_block = var.private_subnets[1]
    gateway_id = aws_nat_gateway.nat_gateway_subnet2.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-private-rt-2"
  }
}

resource "aws_route_table_association" "private_subnet_az2_rt_association" {
  subnet_id      = aws_subnet.private_subnet_az2.id
  route_table_id = aws_route_table.private_route_table_2.id
}


# associate private subnet az1 to "private route table 1"
resource "aws_route_table_association" "private_subnet_az1_rt_association" {
  subnet_id      = aws_subnet.private_subnet_az1.id
  route_table_id = aws_route_table.private_route_table_1.id
}









