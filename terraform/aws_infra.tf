### Demo Environment ###

### AWS Provider #
provider "aws" {
  region = "us-west-2"
}

### Security Group for Instance ###
resource "aws_security_group" "demo_security_group" {
  tags {
    Name = "${var.sg_name}"
    env  = "${var.sg_env}"
  }

  name        = "${var.sg_name}"
  description = "${var.sg_description}"
  vpc_id      = "${var.vpc_id}"
}

ingress {
	from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["${var.cidr_block_open}"]
}

ingress {
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["${var.cidr_block_internal}"]
}

ingress {
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["${var.cidr_block_open}"]
}

egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["${var.cidr_block_open}"]
}

### Security Group for Load Balancer ###
resource "aws_security_group" "sg_load_balancer"















