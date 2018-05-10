#### Infrastructure for Real-Time-Captioning using modules
provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    region = "us-west-2"
    bucket = "terraform-state-rtc"
    key    = "rtc-prod/terraform.tfstate"
  }
}

data "terraform_remote_state" "subnet" {
  backend = "s3"

  config {
    bucket = "terraform-state-rtc"
    key    = "basic-infra/terraform.tfstate"
    region = "us-west-2"
  }
}

module "security-group-lb" {
  source = "../modules/security-groups/lb-sg"
  region = "us-west-2"
}

module "security-group-web" {
  source = "../modules/security-groups/web-server-sg"
}

module "rtc-prod" {
  source = "../modules/web-server"
  ami    = "ami-761d6b0e"

  #private-subnet        = "${data.terraform_remote_state.subnet.private_subnet_2a-id}"
  private-subnet        = "subnet-af51c4d6"
  web_security_group_id = "${module.security-group-web.web-sg-id}"
  env                   = "prod"
  instance_name         = "rtc-prod"
  ec2-key-name          = "rtc"
  region                = "us-west-2"
}

module "mongodb" {
  source = "../modules/web-server"
  ami    = "ami-761d6b0e"

  #private-subnet        = "${data.terraform_remote_state.subnet.private_subnet_2a-id}"
  private-subnet        = "subnet-af51c4d6"
  web_security_group_id = "${module.security-group-web.web-sg-id}"
  env                   = "prod"
  instance_name         = "mongodb"
  ec2-key-name          = "rtc"
  region                = "us-west-2"
}

module "load-balancer" {
  source            = "../modules/load-balancer"
  env               = "prod"
  elb-name          = "prod-load-balancer"
  lb_security_group = "${module.security-group-lb.lb-sg-id}"

  // public_subnets    = ["${data.terraform_remote_state.subnet.public_subnet_2a-id}", "${data.terraform_remote_state.subnet.public_subnet_2b-id}", "${data.terraform_remote_state.subnet.public_subnet_2a-id}"]
  public_subnets = ["subnet-6952c710", "subnet-134ef958", "subnet-a6f19efc"]
  instances      = ["${module.rtc-prod.id}"]
}
