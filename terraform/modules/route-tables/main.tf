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
  description = "id for internet gateway"
}

variable "nat_gateway" {
  description = "ID for nat gateway"
}

variable "public_subnet_2a" {
  description = "ID for public subnet 2a"
}

variable "public_subnet_2b" {
  description = "ID for public subnet 2b"
}

variable "public_subnet_2c" {
  description = "ID for public subnet 2c"
}

variable "private_subnet_2a" {
  description = "ID for private subnet 2a"
}

variable "private_subnet_2b" {
  description = "ID for private subnet 2b"
}

variable "private_subnet_2c" {
  description = "ID for private subnet 2c"
}
