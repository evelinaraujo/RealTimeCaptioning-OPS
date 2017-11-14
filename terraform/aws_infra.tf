### Demo Environment ###

### AWS Provider #
provider "aws" {
  region = "var.region"
}

resource "aws_instance" "webserver-b" {
    ami = "${var.ami}"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${var.demo_security_group}"]
    subnet_id = "${aws_subnet.private_subnet_us_west_2b.id}"
    associate_public_ip_address = false
    key_name = "rtc"

    tags {
        Name = "webserver-b"
        Service = "curriculum"
    }
}

resource "aws_instance" "webserver-c" {
    ami = "ami-5ec1673e"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.web_server_security.id}"]
    subnet_id = "${aws_subnet.private_subnet_us_west_2c.id}"
    associate_public_ip_address = false
    key_name = "cit360"

    tags {
        Name = "webserver-c"
        Service = "curriculum"
    }
}















