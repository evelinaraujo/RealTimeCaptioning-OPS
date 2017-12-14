#### Infrastructure for Real-Time-Captioning using modules

provider "aws" {
  region = "us-west-2"
}

module "subnets" {
  source = "../modules/subnets"
}

module "internet-gateways" {
  source           = "../modules/gateways"
  public_subnet_2a = "${module.subnets.public_subnet_2a-id}"
  region           = "us-west-2a"
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

module "security-group-lb" {
  source = "../modules/security-groups/lb-sg"
  region = "us-west-2a"
}

module "security-group-web" {
  source = "../modules/security-groups/web-server-sg"
  region = "us-west-2a"
}

module "bastion" {
  source           = "../modules/bastion"
  ssh_bastion-sg   = "${module.security-group-web.bastion-sg-id}"
  public_subnet_2a = "${module.subnets.public_subnet_2a-id}"
  bastion-ssh-key  = "~/.ssh/bastion.pem"
}

module "web-server-1" {
  source                = "../modules/web-server"
  ami                   = "ami-316eb049"
  private-subnet        = "${module.subnets.private_subnet_2b-id}"
  web_security_group_id = "${module.security-group-web.web-sg-id}"
  env                   = "demo"
  instance_name         = "rtc-demo-1"
  bastion-host          = "${module.bastion.bastion-id}"
  ec2-ssh-key              = "~/.ssh/rtc.pem"
  region                = "us-west-2a"
}

module "web-server-2" {
  source                = "../modules/web-server"
  ami                   = "ami-316eb049"
  private-subnet        = "${module.subnets.private_subnet_2c-id}"
  web_security_group_id = "${module.security-group-web.web-sg-id}"
  env                   = "demo"
  instance_name         = "rtc-demo-2"
  bastion-host          = "${module.bastion.bastion-id}"
  ec2-ssh-key              = "~/.ssh/rtc.pem"
  region                = "us-west-2b"
}
