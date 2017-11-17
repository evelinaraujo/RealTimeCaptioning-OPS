## AWS Provider
provider "aws" {
  region = "${var.region}"
}

## Elastic IP address for the NAT gateway
resource "aws_eip" "rtc_eip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.gateway"]
}

##Internet Gateway
##Internet Gateway placed in public route table for public subnets.

resource "aws_internet_gateway" "gateway" {
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "gateway"
  }
}

# NAT Gateway
## It will be placed in the private route table for private subnets

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = "${aws_eip.rtc_eip.id}"
  subnet_id     = "${var.public_subnet_us_west_2a}"
  depends_on    = ["aws_internet_gateway.gateway"]
}

### Variables ###

variable "vpc_id" {
  default = "vpc-d4ae8db2"
}

variable "public_subnet_us_west_2a" {
  default = "subnet-50d09c36"
}

variable "region" {
  default = "us-west-2"
}

### Outputs 

output "Elastic_ip" {
  value = "${aws_eip.rtc_eip.id}"
}

output "Internet Gateway" {
  value = "${aws_internet_gateway.gateway.id}"
}
