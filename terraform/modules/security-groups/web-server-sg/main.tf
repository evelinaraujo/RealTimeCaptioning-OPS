## AWS Provider
provider "aws" {
  region = "us-west-2"
}

#### Security Group for Instances web-demo and web-demo-1
#Security Group for Instance
resource "aws_security_group" "web-server-sg" {
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_block_aws}"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_block_open}"]
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
    cidr_blocks = ["${var.cidr_block_open}"]
  }
}

#### OUTPUTS ####
output "web-sg-id" {
  value = "${aws_security_group.web-server-sg.id}"
}

variable "vpc_id" {
  default = "vpc-d4ae8db2"
}

variable "cidr_block_open" {
  default = "0.0.0.0/0"
}

variable "cidr_block_aws" {
  default = "172.31.0.0/16"
}
