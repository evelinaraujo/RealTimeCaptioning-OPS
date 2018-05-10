#### Infrastructure for Real-Time-Captioning using modules

provider "aws" {
  region = "us-west-2"
}

module "security-group-lb" {
  source = "../modules/security-groups/lb-sg"
  region = "us-west-2"
}

module "security-group-web" {
  source = "../modules/security-groups/web-server-sg"
  region = "us-west-2"
}

module "bastion" {
  source           = "../modules/bastion"
  ssh_bastion-sg   = "${module.security-group-web.bastion-sg-id}"
  public_subnet_2a = "${module.subnets.public_subnet_2a-id}"
  bastion-key-name = "bastion"
}

module "rtc-prod" {
  source                = "../modules/web-server"
  ami                   = "ami-761d6b0e"
  private-subnet        = "${module.subnets.private_subnet_2b-id}"
  web_security_group_id = "${module.security-group-web.web-sg-id}"
  env                   = "prod"
  instance_name         = "rtc-prod"
  ec2-key-name          = "rtc"
  region                = "us-west-2"
}

module "mongodb" {
  source                = "../modules/web-server"
  ami                   = "ami-761d6b0e"
  private-subnet        = "${module.subnets.private_subnet_2b-id}"
  web_security_group_id = "${module.security-group-web.web-sg-id}"
  env                   = "prod"
  instance_name         = "mongodb"
  ec2-key-name          = "rtc"
  region                = "us-west-2"

}

module "load-balancer" {
  source            = "../modules/load-balancer"
  env               = "demo"
  elb-name          = "prod-load-balancer"
  lb_security_group = "${module.security-group-lb.lb-sg-id}"
  public_subnets    = ["${module.subnets.public_subnet_2a-id}", "${module.subnets.public_subnet_2b-id}", "${module.subnets.public_subnet_2c-id}"]
  instances         = ["${module.rtc-prod.id}"]
}
