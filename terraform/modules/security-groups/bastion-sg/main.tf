## AWS Provider
provider "aws" {
  region = "${var.region}"
}

## Security Group that allows SSH to Bastion host

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


