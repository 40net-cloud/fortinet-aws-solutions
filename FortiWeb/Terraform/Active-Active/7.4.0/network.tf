// Internet Gateway
resource "aws_internet_gateway" "fwbvmigw" {
  vpc_id = aws_vpc.fwbvm-vpc.id
  tags = {
    Name = "fwbvm-igw"
  }
}

// Route Table

resource "aws_route_table" "fwbvmpublic1rt" {
  vpc_id = aws_vpc.fwbvm-vpc.id

  tags = {
    Name = "fwbvm-public1-rt"
  }
}

resource "aws_route_table" "fwbvmprivate1rt" {
  vpc_id = aws_vpc.fwbvm-vpc.id

  tags = {
    Name = "fwbvm-private1-rt"
  }
}

resource "aws_route_table" "fwbvmpublic2rt" {
  vpc_id = aws_vpc.fwbvm-vpc.id

  tags = {
    Name = "fwbvm-public2-rt"
  }
}

resource "aws_route_table" "fwbvmprivate2rt" {
  vpc_id = aws_vpc.fwbvm-vpc.id

  tags = {
    Name = "fwbvm-private2-rt"
  }
}

// Route Rules

resource "aws_route" "externalroute1" {
  route_table_id         = aws_route_table.fwbvmpublic1rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.fwbvmigw.id
}

resource "aws_route" "internalroute1" {
  depends_on             = [aws_instance.fwbactive1]
  route_table_id         = aws_route_table.fwbvmprivate1rt.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.active1eth1.id

}

resource "aws_route" "externalroute2" {
  route_table_id         = aws_route_table.fwbvmpublic2rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.fwbvmigw.id
}

resource "aws_route" "internalroute2" {
  depends_on             = [aws_instance.fwbactive1]
  route_table_id         = aws_route_table.fwbvmprivate2rt.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.active2eth1.id

}

// Route Table Association

resource "aws_route_table_association" "public1associate" {
  subnet_id      = aws_subnet.publicsubnet1.id
  route_table_id = aws_route_table.fwbvmpublic1rt.id
}

resource "aws_route_table_association" "private1associate" {
  subnet_id      = aws_subnet.privatesubnet1.id
  route_table_id = aws_route_table.fwbvmprivate1rt.id
}

resource "aws_route_table_association" "public2associate" {
  subnet_id      = aws_subnet.publicsubnet2.id
  route_table_id = aws_route_table.fwbvmpublic2rt.id
}

resource "aws_route_table_association" "private2associate" {
  subnet_id      = aws_subnet.privatesubnet2.id
  route_table_id = aws_route_table.fwbvmprivate2rt.id
}

// NLB EIP

resource "aws_eip" "LBPublicIP" {
  depends_on = [aws_instance.fwbactive1]
  domain     = "vpc"
}

// FortiWeb Public IPs

resource "aws_eip" "Active1PublicIP" {
  depends_on        = [aws_instance.fwbactive1]
  domain            = "vpc"
  network_interface = aws_network_interface.active1eth0.id
}

resource "aws_eip" "Active2PublicIP" {
  depends_on        = [aws_instance.fwbactive2]
  domain            = "vpc"
  network_interface = aws_network_interface.active2eth0.id
}

// VPC Security Group

resource "aws_security_group" "public_allow" {
  name        = "Public Allow"
  description = "Public Allow traffic"
  vpc_id      = aws_vpc.fwbvm-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public Allow"
  }
}

resource "aws_security_group" "allow_all" {
  name        = "Allow All"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.fwbvm-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private Allow"
  }
}