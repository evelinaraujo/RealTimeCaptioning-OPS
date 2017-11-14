## AWS Provider
provider "aws" {
  region = "${var.region}"
}

##Internet Gateway
##Internet Gateway placed in public route table for public subnets.

resource "aws_internet_gateway" "gateway" {
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "gateway"
  }
}

#Public Route Tables
#This route table will have the Internet Gateway in the default route 
# and will be used by the public subnets.

resource "aws_route_table" "public_route_table" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway.id}"
  }

  tags = {
    Name = "Public route table"
  }
}

### Route Table Associations
resource "aws_route_table_association" "public_subnet_us_west_2a_association" {
    subnet_id = "${aws_subnet.public_subnet_us_west_2a.id}"
    route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_route_table_association" "public_subnet_us_west_2b_association" {
    subnet_id = "${aws_subnet.public_subnet_us_west_2b.id}"
    route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_route_table_association" "public_subnet_us_west_2c_association" {
    subnet_id = "${aws_subnet.public_subnet_us_west_2c.id}"
    route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_route_table_association" "private_subnet_us_west_2a_association" {
    subnet_id = "${aws_subnet.private_subnet_us_west_2a.id}"
    route_table_id = "${aws_route_table.private_route_table.id}"
}

resource "aws_route_table_association" "private_subnet_us_west_2b_association" {
    subnet_id = "${aws_subnet.private_subnet_us_west_2b.id}"
    route_table_id = "${aws_route_table.private_route_table.id}"
}

resource "aws_route_table_association" "private_subnet_us_west_2c_association" {
    subnet_id = "${aws_subnet.private_subnet_us_west_2c.id}"
    route_table_id = "${aws_route_table.private_route_table.id}"
}

## Elastic IP address for the NAT gateway
resource "aws_eip" "rtc_eip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.gateway"]
}

# NAT Gateway
## It will be placed in the private route table for private subnets

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = "${aws_eip.rtc_eip.id}"
  subnet_id     = "${aws_subnet.public_subnet_us_west_2a.id}"
  depends_on    = ["aws_internet_gateway.gateway"]
}

#Create a private route table. 
#This route table will have the NAT Gateway in the default route 
#and will be used by the private subnets.

resource "aws_route_table" "private_route_table" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat_gateway.id}"
  }

  tags {
    Name = "Private route table"
  }
}

resource "aws_subnet" "public_subnet_us_west_2a" {
  #Subnets

  ##3 public subnets. 

  #A public subnet uses an Internet Gateway in its routing table for the default route.

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

### Security Group that allows SSH to Bastion host

resource "aws_security_group" "allow_ssh_bastion" {
  name        = "allow_ssh_bastion"
  vpc_id      = "${var.vpc_id}"
  description = "Allow local inbound ssh traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_block_aws}", "${var.cidr_block_eduroam}", "${var.cidr_block_csun}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

### Bastion Host ###

resource "aws_instance" "bastion" {
  ami                         = "${var.ami}"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.allow_ssh_bastion.id}"]
  subnet_id                   = "${aws_subnet.public_subnet_us_west_2a.id}"
  associate_public_ip_address = true
  key_name                    = "rtc"

  tags {
    Name = "bastion"
  }
}

### Security Group for Load Balancer ###

resource "aws_security_group" "lb_security_group" {
  name        = "lb_security_group"
  vpc_id      = "${var.vpc_id}"
  description = "Allow web incoming traffic to load balancer"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
