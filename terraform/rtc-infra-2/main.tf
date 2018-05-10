#### Infrastructure for Real-Time-Captioning using modules

provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    region         = "us-west-2"
    bucket         = "terraform-state-rtc"          #
    key            = "basic-infra/terraform.tfstate" #
  }
}


data "terraform_remote_state" "subnet" {
  backend = "s3"

  config {
    bucket = "opg-remote-state"
    key    = "prometheus-prod/terraform.tfstate"
    region = "${var.region}"
  }
}


data "terraform_remote_state" "subnet" {
  backend = "s3"

  config {
    bucket = "terraform-state-rtc"
    key    = "rtc-prod/terraform.tfstate"
    region = "us-west-2"
  }
}

module "security-group-lb" {
  source = "../../modules/security-groups/lb-sg"
  region = "us-west-2"
}

module "security-group-web" {
  source = "../../modules/security-groups/web-server-sg"
  region = "us-west-2"
}

module "rtc-prod" {
  source                = "../../modules/web-server"
  ami                   = "ami-761d6b0e"
  private-subnet        = "${module.subnets.private_subnet_2b-id}"
  web_security_group_id = "${module.security-group-web.web-sg-id}"
  env                   = "prod"
  instance_name         = "rtc-prod"
  ec2-key-name          = "rtc"
  region                = "us-west-2"
}

module "mongodb" {
  source                = "../../modules/web-server"
  ami                   = "ami-761d6b0e"
  private-subnet        = "${module.subnets.private_subnet_2b-id}"
  web_security_group_id = "${module.security-group-web.web-sg-id}"
  env                   = "prod"
  instance_name         = "mongodb"
  ec2-key-name          = "rtc"
  region                = "us-west-2"

}

module "load-balancer" {
  source            = "../../modules/load-balancer"
  env               = "demo"
  elb-name          = "prod-load-balancer"
  lb_security_group = "${module.security-group-lb.lb-sg-id}"
  public_subnets    = ["${module.subnets.public_subnet_2a-id}", "${module.subnets.public_subnet_2b-id}", "${module.subnets.public_subnet_2c-id}"]
  instances         = ["${module.rtc-prod.id}"]
}
