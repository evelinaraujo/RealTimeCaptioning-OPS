#### Load Balancer ####

### AWS Provider #
provider "aws" {
  region = "${var.region}"
}

resource "aws_elb" "elb" {
  name            = "${var.elb-name}"
  security_groups = ["${var.lb_security_group}"]
  subnets         = ["${var.public_subnet_a}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${var.rtc-certificate}"
  }

### create s3 load balancer log
#  access_logs {
#   bucket = "${aws_s3_bucket.s3-lb-logs.id}"
#  }

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

}

#### variables
variable region {
	default = "us-west-2"
}

variable elb-name {
	default = "demo-load-balancer"
}

variable lb_security_group {
	default = "sg-f4475089"
}

variable public_subnet_a {
	default = "subnet-50d09c36"
}

variable rtc-certificate {
	default = "arn:aws:acm:us-west-2:636693391160:certificate/c4fbf184-91e0-4a46-8a63-a907f806aa88"
}

variable instances {
  default = ["i-0a6cb5f9c9a4492c9", "i-0aa30005adcb703b9"]
}

variable healthy-threshold {
  default = "10"
}

variable unhealthy-threshold {
  default = "2"
}

variable health-target {
  default = "HTTP:80/"
}

variable health-interval {
  default = "30"
}

variable health-timeout {
  default = "5"
}

variable connection-draining {
  default = "true"
}

variable connection-draining-timeout {
  default = "300"
}

