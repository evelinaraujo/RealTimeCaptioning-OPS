## AWS Provider
provider "aws" {
  region = "${var.region}"
}

### Bastion Host ###

resource "aws_instance" "bastion" {
  ami                         = "${var.ami}"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${var.ssh_bastion}"]
  subnet_id                   = "${var.public_subnet_2a}"
  associate_public_ip_address = true
  key_name                    = "rtc"

  tags {
    Name = "bastion"
  }
}

### Variables

variable "ami"{
	default = "ami-6e1a0117" #standard ubuntu 16.04 ami
 }

variable "region" {
  default = "us-west-2"
}

variable "ssh_bastion" {
	default = "sg-3d465140"
}

variable "public_subnet_2a" {
	default = "subnet-50d09c36"
}

### Outputs 
output "bastion id" {
  value = "${aws_instance.bastion.id}"
}

