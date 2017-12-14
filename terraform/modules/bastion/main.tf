## AWS Provider
provider "aws" {
  region = "${var.region}"
}

### Bastion Host ###

resource "aws_instance" "bastion" {
  ami                         = "${var.ami}"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${var.ssh_bastion-sg}"]
  subnet_id                   = "${var.public_subnet_2a}"
  associate_public_ip_address = true
  key_name                    = "${var.bastion-ssh-key}"

  tags {
    Name = "bastion"
  }
}

### Variables

variable "ami" {
  description = "ami ID that will be used for the bastion instance, Linux"
  default     = "ami-bf4193c7"
}

variable "region" {
  description = "Region in which bastion will live"
  default     = "us-west-2"
}

variable "ssh_bastion-sg" {
  description = "security group ID for bastion host"
}

variable "public_subnet_2a" {
  description = " subnet in which bastion will be hosted"
}

variable "bastion-ssh-key" {
  description = "path to bastion host key"
}

### Outputs 
output "bastion-id" {
  value = "${aws_instance.bastion.id}"
}
