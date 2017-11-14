variable "vpc_id" {
  default = "vpc-d4ae8db2"
}

variable "region" {
  default = "us-west-2"
}

variable "ami" {
  default = "ami-0a00ce72"
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
