## AWS Provider
provider "aws" {
  region = "${var.region}"
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
    from_port   = 443
    to_port     = 443
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
