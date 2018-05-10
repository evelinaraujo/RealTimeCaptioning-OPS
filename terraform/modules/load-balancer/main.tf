#### Load Balancer ####

### AWS Provider #
provider "aws" {
  region = "${var.region}"
}


resource "aws_elb" "elb" {
  name            = "${var.elb-name}"
  security_groups = ["${var.lb_security_group}"]
  subnets         = ["${var.public_subnets}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 8080
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${var.rtc-certificate}"
  }

  health_check {
    healthy_threshold   = "${var.healthy-threshold}"
    unhealthy_threshold = "${var.unhealthy-threshold}"
    target              = "${var.health-target}"
    interval            = "${var.health-interval}"
    timeout             = "${var.health-timeout}"
  }

  connection_draining         = "${var.connection-draining}"
  connection_draining_timeout = "${var.connection-draining-timeout}"
  instances                   = ["${var.instances}"]

  tags {
    name = "${var.elb-name}"
    env  = "${var.env}"
  }
}

#### variables
variable "region" {
  default = "us-west-2"
}

variable "elb-name" {
  description = "name of the load balancer"
}

variable "lb_security_group" {
  description = "security group for the load balancer"
}

variable "env" {
  description = "environment: demo, stage, prod, test"
}

variable "public_subnets" {
  description = "id for public subnets"
  type        = "list"
}

variable "rtc-certificate" {
  default = "arn:aws:acm:us-west-2:636693391160:certificate/c4fbf184-91e0-4a46-8a63-a907f806aa88"
}

variable "instances" {
  description = "list of instances behind the load balancer"
  type        = "list"
}

variable "healthy-threshold" {
  default = "10"
}

variable "unhealthy-threshold" {
  default = "2"
}

variable "health-target" {
  default = "HTTP:8080/index.html"
}

variable "health-interval" {
  default = "10"
}

variable "health-timeout" {
  default = "2"
}

variable "connection-draining" {
  default = "true"
}

variable "connection-draining-timeout" {
  default = "300"
}


