## AWS Provider
provider "aws" {
  region = "${var.region}"
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

variable "vpc_id" {
  default = "vpc-d4ae8db2"
}

variable "region" {
  description = "Region for security group"
}
