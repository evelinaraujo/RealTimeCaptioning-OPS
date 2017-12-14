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

variable "region" {
  description = "Region for security group"
}

variable "vpc_id" {
  description = "VPC ID"
  default     = "vpc-d4ae8db2"
}

variable "cidr_block_aws" {
  description = "cidr that contains AWS IP range"
  default     = "172.31.0.0/16"
}

variable "cidr_block_eduroam" {
  description = "CIDR that contains eduroam's IP range"
  default     = "172.28.0.0/16"
}

variable "cidr_block_csun" {
  description = "CIDR that contain's CSUN's IP range"
  default     = "130.166.0.0/16"
}

variable "cidr_block_open" {
  description = "open cidr notation"
  default     = "0.0.0.0/0"
}

#### OUTPUTS ####
output "bastion-sg-id" {
  value = "${aws_security_group.allow_ssh_bastion.id}"
}

output "web-sg-id" {
  value = "${aws_security_group.web-server-sg.id}"
}
