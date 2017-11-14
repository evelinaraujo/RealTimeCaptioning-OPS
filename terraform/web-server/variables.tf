##Variables - Instance
variable "region" {
        description = "AWS Region"
        default     = "us-west-2"
}
variable "instance_name" {
        description = "Name of the Instance"
        default     = "rtc-demo"
}
variable "vpc_id" {
    default = "vpc-d4ae8db2"
}

variable "demo_security_group_id"
    default = ""
