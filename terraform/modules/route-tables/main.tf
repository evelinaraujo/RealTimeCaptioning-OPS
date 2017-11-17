## AWS Provider
provider "aws" {
  region = "${var.region}"
}

#Public Route Tables
#This route table will have the Internet Gateway in the default route 
# and will be used by the public subnets.

resource "aws_route_table" "public_route_table" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.internet_gateway}"
  }

  tags = {
    Name = "Public route table"
  }
}

#Create a private route table. 
#This route table will have the NAT Gateway in the default route 
#and will be used by the private subnets.

resource "aws_route_table" "private_route_table" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.nat_gateway}"
  }

  tags {
    Name = "Private route table"
  }
}

### Route Table Associations
resource "aws_route_table_association" "public_subnet_us_west_2a_association" {
  subnet_id      = "${var.public_subnet_2a}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_route_table_association" "public_subnet_us_west_2b_association" {
  subnet_id      = "${var.public_subnet_2b}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_route_table_association" "public_subnet_us_west_2c_association" {
  subnet_id      = "${var.public_subnet_2c}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_route_table_association" "private_subnet_us_west_2a_association" {
  subnet_id      = "${var.private_subnet_2a}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}

resource "aws_route_table_association" "private_subnet_us_west_2b_association" {
  subnet_id      = "${var.private_subnet_2b}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}

resource "aws_route_table_association" "private_subnet_us_west_2c_association" {
  subnet_id      = "${var.private_subnet_2c}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}

#### Variables ####
variable "vpc_id" {
  default = "vpc-d4ae8db2"
}

variable "region" {
  default = "us-west-2"
}

variable "internet_gateway" {
  default = "igw-56616831"
}

variable "nat_gateway" {
  default = "nat-014b77c5d847e48c8"
}

variable "public_subnet_2a" {
  default = "subnet-50d09c36"
}

variable "public_subnet_2b" {
  default = "subnet-d085e998"
}

variable "public_subnet_2c" {
  default = "subnet-5e4a4705"
}

variable "private_subnet_2a" {
  default = "subnet-b6d79bd0"
}

variable "private_subnet_2b" {
  default = "subnet-9684e8de"
}

variable "private_subnet_2c" {
  default = "subnet-4149441a"
}
