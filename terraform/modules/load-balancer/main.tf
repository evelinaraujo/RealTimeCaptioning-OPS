#### Load Balancer ####

### AWS Provider #
provider "aws" {
  region = "${var.region}"
}

## MODULE - S3 BUCKET - LB LOGS ##
resource "aws_s3_bucket" "s3-logs" {
  bucket = "${var.elb-name}-logs"
  acl    = "${var.s3-acl}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "S3lbAccessLogs-${var.elb-name}",
  "Statement": [
    {
      "Sid": "AllowLBLogsAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.user}"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${var.elb-name}-logs/AWSLogs/*"
    }
  ]
}
POLICY

  tags {
    Name = "${var.elb-name}-logs"
    env  = "${var.env}"
  }
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
variable "region " {
  default = "us-west-2"
}

variable "elb-name" {
  description = "name of the load balancer"
}

variable "lb_security_group " {
  description = "security group for the load balancer"
}

variable "public_subnet_a " {
  description = "id for public subnet a"
}

variable "rtc-certificate " {
  default = "arn:aws:acm:us-west-2:636693391160:certificate/c4fbf184-91e0-4a46-8a63-a907f806aa88"
}

variable "instances " {
  description = "list of instances behind the load balancer"
  type        = "list"
}

variable "healthy-threshold " {
  default = "10"
}

variable "unhealthy-threshold " {
  default = "2"
}

variable "health-target " {
  default = "HTTP:80/"
}

variable "health-interval " {
  default = "30"
}

variable "health-timeout " {
  default = "5"
}

variable "connection-draining " {
  default = "true"
}

variable "connection-draining-timeout " {
  default = "300"
}

variable "user" {
  description = "arn of user"
}

variable "s3-acl" {
  description = "public or private accessibility"
}
