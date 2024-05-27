// AWS VPC 
resource "aws_vpc" "fwbvm-vpc" {
  cidr_block           = var.vpccidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = "FortiWeb VPC"
  }
}

// AWS Subnets AZ1

resource "aws_subnet" "publicsubnet1" {
  vpc_id            = aws_vpc.fwbvm-vpc.id
  cidr_block        = var.publiccidr1
  availability_zone = var.az1
  map_public_ip_on_launch = true
  tags = {
    Name = "Public1 Subnet"
  }
}

resource "aws_subnet" "privatesubnet1" {
  vpc_id            = aws_vpc.fwbvm-vpc.id
  cidr_block        = var.privatecidr1
  availability_zone = var.az1
  tags = {
    Name = "Private1 Subnet"
  }
}

// AWS Subnets AZ2

resource "aws_subnet" "publicsubnet2" {
  vpc_id            = aws_vpc.fwbvm-vpc.id
  cidr_block        = var.publiccidr2
  availability_zone = var.az2
  map_public_ip_on_launch = true
  tags = {
    Name = "Public2 Subnet"
  }
}

resource "aws_subnet" "privatesubnet2" {
  vpc_id            = aws_vpc.fwbvm-vpc.id
  cidr_block        = var.privatecidr2
  availability_zone = var.az2
  tags = {
    Name = "Private2 Subnet"
  }
}