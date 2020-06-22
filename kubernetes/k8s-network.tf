# kubernetes VPC
resource "aws_vpc" "k8s_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "k8s-vpc"
    "kubernetes.io/cluster/k8s-israrul-demo"  =   "owned"
  }
}

# Subnets
resource "aws_subnet" "k8s_subnet_1" {
  vpc_id                  = aws_vpc.k8s_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name                                    =   "k8s-subnet-1"
    "kubernetes.io/cluster/k8s-israrul-demo"  =   "owned"
  }
}

# Internet GW
resource "aws_internet_gateway" "k8s_gw" {
  vpc_id = aws_vpc.k8s_vpc.id

  tags = {
    Name                                    = "k8s-igw"
    "kubernetes.io/cluster/k8s-israrul-demo"  = "owned"
  }
}

# route tables
resource "aws_route_table" "k8s_rtb_pub" {
  vpc_id = aws_vpc.k8s_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s_gw.id
  }

  tags = {
    Name                                    = "k8s-rtb"
    "kubernetes.io/cluster/k8s-israrul-demo"  = "owned"
  }
}

# route associations public
resource "aws_route_table_association" "k8s_rtb_subnet_assoc_1" {
  subnet_id      = aws_subnet.k8s_subnet_1.id
  route_table_id = aws_route_table.k8s_rtb_pub.id
}