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

#### Security Group for Instances web-demo and web-demo-1
#Security Group for Instance
resource "aws_security_group" "web-demo-sg" {
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.cidr_block_open}"]
  }
}

### Variables ###

variable "vpc_id" {
  default = "vpc-d4ae8db2"
}

variable "region" {
  default = "us-west-2"
}

variable "cidr_block_aws" {
  default = "172.31.0.0/16"
}

variable "cidr_block_csun" {
  default = "130.166.0.0/16"
}

variable "cidr_block_eduroam" {
  default = "172.28.0.0/16"
}

variable "cidr_block_open" {
  default = "0.0.0.0/0"
}

##### Outputs

output "Web server security group" {
  value = "${aws_security_group.web-demo-sg.id}"
}
