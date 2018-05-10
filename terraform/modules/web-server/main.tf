### AWS Provider #
provider "aws" {
  region = "${var.region}"
}

resource "aws_instance" "ec2_instance" {
  ami                         = "${var.ami}"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${var.web_security_group_id}"]
  subnet_id                   = "${var.private-subnet}"
  associate_public_ip_address = false
  key_name                    = "${var.ec2-key-name}"

  tags {
    Name = "${var.instance_name}"
    Env  = "${var.env}"
  }
}

##Variables - Instance

variable "region" {
  description = "AWS Region"
}

variable "ami" {
  description = "ami for ec2 instance"

  #default = "ami-316eb049"
}

variable "ec2-key-name" {
  description = "name of key"
}

variable "env" {
  description = "Environment: demo, stage, test or demo?"
}

variable "instance_name" {
  description = "Name of the Instance"
}

variable "vpc_id" {
  default = "vpc-d4ae8db2"
}

variable "web_security_group_id" {
  description = "ID for web-server's security group"
}

variable "private-subnet" {
  description = "ID of private subnet. Choose different subnet for instances created in different availability zones"
}

### Output
output "id" {
  value = "${aws_instance.ec2_instance.id}"
}

output "private_ip" {
  value = "${aws_instance.ec2_instance.private_ip}"
}
