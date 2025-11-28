
terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}




resource "aws_vpc" "VPC" {
  cidr_block = "${var.net_prefix}.0.0/16"
  tags = {
    Name =  var.vpc_name
  }
}

resource "aws_subnet" "Control" {
  vpc_id            = aws_vpc.VPC.id
  availability_zone = var.Control_Subnet_AZ
  cidr_block        = "${var.net_prefix}.10.0/24"   #Changed from 111 to 10
  map_public_ip_on_launch = true
    tags = {
    Name =  "${var.vpc_name}-Control-Subnet"
    }
  }

resource "aws_subnet" "Managed1" {
  vpc_id            = aws_vpc.VPC.id
  availability_zone = var.Managed_Subnet2_AZ
  cidr_block = "${var.net_prefix}.50.0/24"    #Changed from .222 to .50 + .60
  map_public_ip_on_launch = true
    tags = {
    Name =  "${var.vpc_name}-Managed-Subnet1"
    }
}

resource "aws_subnet" "Managed2" {
  vpc_id            = aws_vpc.VPC.id
  availability_zone = var.Managed_Subnet1_AZ
  cidr_block = "${var.net_prefix}.60.0/24"
  map_public_ip_on_launch = true
    tags = {
    Name =  "${var.vpc_name}-Managed-Subnet2"
    }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.VPC.id
    tags = {
    Name =  "${var.vpc_name}-Ansible-IGW"
    }
}

resource "aws_security_group" "Control_SG" {
  name        = "SG for Control Subnet"
  description = "Allow SSH/HTTP from specific IP and from VPC, Allow Internet outband"
  vpc_id      = aws_vpc.VPC.id
  tags = {
    Name  = "SG for Control Subnet"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.source_ip, aws_vpc.VPC.cidr_block]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.source_ip, aws_vpc.VPC.cidr_block]
  }
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [var.source_ip, aws_vpc.VPC.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "Managed_SG" {
  name        = "Internal_SSH_SG_v2"
  description = "Allow SSH only from VPC and full internet outbound"
  vpc_id      = aws_vpc.VPC.id
  tags = {
    Name  = "Internal_SSH_SG_v2"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.VPC.cidr_block]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.VPC.cidr_block]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.VPC.cidr_block]
  }
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.VPC.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_route_table" "Internet_Route" {
  vpc_id = aws_vpc.VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name  = "Internet_Route"
  }

}

resource "aws_route_table_association" "Control_Subnet_RTA" {
  subnet_id      = aws_subnet.Control.id
  route_table_id = aws_route_table.Internet_Route.id
}


resource "aws_eip" "NAT_EIP" {
  
}

resource "aws_nat_gateway" "gw" {
  depends_on = [ aws_route_table_association.Control_Subnet_RTA ]
  subnet_id  = aws_subnet.Control.id
  allocation_id = aws_eip.NAT_EIP.id
}


resource "aws_route_table" "Route_to_NAT" {
  vpc_id = aws_vpc.VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw.id
  }

  tags = {
    Name  = "NAT_Internet_Routing"
  }

}

resource "aws_route_table_association" "Managed_Subnet1_RTA" {   #Updated RTAs for 2 managed subnets
  subnet_id      = aws_subnet.Managed1.id
  route_table_id = aws_route_table.Internet_Route.id
}

resource "aws_route_table_association" "Managed_Subnet2_RTA" {
  subnet_id      = aws_subnet.Managed2.id
  route_table_id = aws_route_table.Internet_Route.id
}
