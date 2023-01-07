variable "environment" {
  default = "deop"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
  description = "this is our vpc cidr block"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
  description = "this is our public subnet cidr block"
}