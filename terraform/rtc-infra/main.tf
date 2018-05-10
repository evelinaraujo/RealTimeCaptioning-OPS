#### Infrastructure for Real-Time-Captioning using modules

provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    region         = "us-west-2"
    bucket         = "terraform-state-rtc"          
    key            = "basic-infra/terraform.tfstate" 
  }
}

module "subnets" {
  source = "../modules/subnets"
}

module "internet-gateways" {
  source           = "../modules/gateways"
  public_subnet_2a = "${module.subnets.public_subnet_2a-id}"
  region           = "us-west-2"
}

module "route-tables" {
  source            = "../modules/route-tables"
  nat_gateway       = "${module.internet-gateways.Nat-Gateway-id}"
  public_subnet_2a  = "${module.subnets.public_subnet_2a-id}"
  public_subnet_2b  = "${module.subnets.public_subnet_2b-id}"
  public_subnet_2c  = "${module.subnets.public_subnet_2c-id}"
  private_subnet_2a = "${module.subnets.private_subnet_2a-id}"
  private_subnet_2b = "${module.subnets.private_subnet_2b-id}"
  private_subnet_2c = "${module.subnets.private_subnet_2c-id}"
  internet_gateway  = "${module.internet-gateways.Internet-Gateway-id}"
}

module "security-group-bastion" {
  source = "../modules/security-groups/bastion-sg"
  region = "us-west-2"
}

module "bastion" {
  source           = "../modules/bastion"
  ssh_bastion-sg   = "${module.security-group-bastion.bastion-sg-id}"
  public_subnet_2a = "${module.subnets.public_subnet_2a-id}"
  bastion-key-name = "bastion"
}
