## AWS Provider
provider "aws" {
  region = "${var.region}"
}
 
  #Subnets

  ##3 public subnets. 

  #A public subnet uses an Internet Gateway in its routing table for the default route.
resource "aws_subnet" "public_subnet_us_west_2a" {

  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "172.31.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"

  tags = {
    Name = "Public Subnet 2a"
  }
}

resource "aws_subnet" "public_subnet_us_west_2b" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "172.31.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2b"

  tags = {
    Name = "Public Subnet 2b"
  }
}

resource "aws_subnet" "public_subnet_us_west_2c" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "172.31.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2c"

  tags = {
    Name = "Public Subnet 2c"
  }
}

### 3 private subnets
# A private subnet uses a NAT gateway in its routing table for the default route.

## 1024 private IP addresses per every availability zone

resource "aws_subnet" "private_subnet_us_west_2a" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "172.31.4.0/22"
  availability_zone = "us-west-2a"

  tags = {
    Name = "Private Subnet 2a"
  }
}

resource "aws_subnet" "private_subnet_us_west_2b" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "172.31.8.0/22"
  availability_zone = "us-west-2b"

  tags = {
    Name = "Private Subnet 2b"
  }
}

resource "aws_subnet" "private_subnet_us_west_2c" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "172.31.12.0/22"
  availability_zone = "us-west-2c"

  tags = {
    Name = "Private Subnet 2c"
  }
}

##### Variables ####
variable "vpc_id" {
  default = "vpc-d4ae8db2"
}

variable "region" {
  default = "us-west-2"
}

#### Outputs 
output "public_subnet_us_west_2a" {
  value = "${aws_subnet.public_subnet_us_west_2a.id}"
}

output "public_subnet_us_west_2b" {
  value = "${aws_subnet.public_subnet_us_west_2b.id}"
}


output "public_subnet_us_west_2c" {
  value = "${aws_subnet.public_subnet_us_west_2c.id}"
}

output "private_subnet_us_west_2a" {
  value = "${aws_subnet.private_subnet_us_west_2a.id}"
}

output "private_subnet_us_west_2b" {
  value = "${aws_subnet.private_subnet_us_west_2b.id}"
}

output "private_subnet_us_west_2c" {
  value = "${aws_subnet.private_subnet_us_west_2c.id}"
}