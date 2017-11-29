### Demo Environment ###

### AWS Provider #
provider "aws" {
  region = "${var.region}"
}

resource "aws_instance" "web-demo" {
  ami                    = "${var.ami}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${var.demo_security_group_id}"]
  subnet_id              = "${var.private-subnet-2b}"

  #Do I need to associate a public ip address?
  associate_public_ip_address = false
  key_name                    = "rtc"

  tags {
    Name = "web-demo"
  }
}

resource "aws_instance" "web-demo-1" {
  ami                    = "${var.ami}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${var.demo_security_group_id}"]
  subnet_id              = "${var.private-subnet-2c}"

  #Do I need to associate a public ip address?
  associate_public_ip_address = false
  key_name                    = "rtc"

  tags {
    Name = "web-demo-1"
  }
}

##Variables - Instance
variable "region" {
  description = "AWS Region"
  default     = "us-west-2"
}

variable "instance_name" {
  description = "Name of the Instance"
  default     = "rtc-demo"
}

variable "vpc_id" {
  default = "vpc-d4ae8db2"
}

variable "demo_security_group_id" {
  default = "sg-df6273a2"
}

variable "ami" {
  # should be an ami from packer
  # for now it is default 
  default = "ami-316eb049"
  #ami-0a00ce72
}

variable "private-subnet-2b" {
  default = "subnet-9684e8de"
}

variable "private-subnet-2c" {
  default = "subnet-4149441a"
}
