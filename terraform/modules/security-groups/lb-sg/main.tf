## AWS Provider
provider "aws" {
  region = "us-west-2"
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

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_block_open}"]
  }

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_block_open}"]
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

output "lb-sg-id" {
  value = "${aws_security_group.lb_security_group.id}"
}

variable "cidr_block_open" {
  description = "open cidr notation"
  default     = "0.0.0.0/0"
}
