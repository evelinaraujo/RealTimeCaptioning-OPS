## AWS Provider
provider "aws" {
  region = ${var.region}
}
##Internet Gateway
##Internet Gateway placed in public route table for public subnets.

resource "aws_internet_gateway" "gateway" {
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "gateway"
  }
}

###NAT Gateway
###Create a single NAT Gateway in any region that will be placed in the private route table for private subnets.

resource "aws_nat_gateway" "nat" {
    allocation_id = "${aws_eip.cit_eip.id}"
    subnet_id = "${aws_subnet.public_subnet_us_west_2a.id}"
    depends_on = ["aws_internet_gateway.gw"]
}

#Route Tables
#Create a public route table. This route table will have the Internet Gateway in the default route and will be used by the public subnets.
#Create a private route table. This route table will have the NAT Gateway in the default route and will be used by the private subnets.

#Subnets
##3 public subnets. 
#A public subnet uses an Internet Gateway in its routing table for the default route.


resource "aws_subnet" "public_subnet_us_west_2a" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "172.31.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-west-2a"
  tags = {
    Name = "Public Subnet 2a"
  }
}

resource "aws_subnet" "public_subnet_us_west_2b" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "172.31.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-west-2b"
  tags = {
    Name = "Public Subnet 2b"
  }
}

resource "aws_subnet" "public_subnet_us_west_2c" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "172.31.3.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-west-2c"
  tags = {
    Name = "Public Subnet 2c"
  }
}

### 3 private subnets
# A private subnet uses a NAT gateway in its routing table for the default route.

## 1024 private IP addresses per every availability zone

resource "aws_subnet" "private_subnet_us_west_2a" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "172.31.4.0/22"
  availability_zone = "us-west-2a"
  tags = {
    Name =  "Private Subnet 2a"
  }
}

resource "aws_subnet" "private_subnet_us_west_2b" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "172.31.8.0/22"
  availability_zone = "us-west-2b"
  tags = {
    Name =  "Private Subnet 2b"
  }
}

resource "aws_subnet" "private_subnet_us_west_2c" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "172.31.12.0/22"
  availability_zone = "us-west-2c"
  tags = {
    Name =  "Private Subnet 2c"
  }
}











#Create 3 private subnets. There should be a private subnet created in each availability zone in the Oregon region (us-west-2a, us-west-2b, us-west-2c). Your private subnets should be “/22” subnets inside the VPC CIDR space. A private subnet uses a NAT gateway in its routing table for the default route.
