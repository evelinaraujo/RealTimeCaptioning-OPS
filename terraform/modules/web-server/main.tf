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
  key_name                    = "${var.ec2-ssh-key}"

  tags {
    Name = "${var.instance_name}"
    Env  = "${var.env}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get install -y python",
    ]

    connection {
      bastion_host        = "${var.bastion-host}"
      bastion_user        = "${var.bastion-user}"
      bastion_private_key = "${file("${var.bastion-ssh-key}")}"
      type                = "ssh"
      user                = "${var.ec2-user}"
      private_key         = "${file("${var.ec2-ssh-key}")}"
    }
  }
}

##Variables - Instance

variable "region" {
  description = "AWS Region"
}

variable "ami" {
  description = "ami for ec2 instance"

  #default = "ami-316eb049"

  #ami-0a00ce72
}

variable "ec2-user" {
  description = "name of the ec2 user"
  default     = "ubuntu"
}

variable "ec2-ssh-key" {
  description = "path to the key used to access ec2 instance"
}

variable "bastion-host" {
  description = "IP address for bastion host"
}

variable "bastion-user" {
  description = "user for bastion instance"
  default     = "ec2-user"
}

variable "bastion-ssh-key" {
  description = "path to bastion host key"
  default     = "~/.ssh/rtc.pem"
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
