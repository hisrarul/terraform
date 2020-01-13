variable "INSTANCE_TYPE" {
  type = "map"
  default = {
      demo = "t2.micro"
      prod = "m4.large"
  }
}

variable "ENV" {
  default = "demo"
}

variable "SUBNET_ID" {
  default = "subnet-fc61bbb1"
}

variable "EXTRA_SGS" {
  type = "list"
  default = ["sg-4527c913"]
}

variable "extra_packages" {
  default = "tilix"
}

variable "external_nameserver" {
  default = "8.8.8.8"
}

variable "NAME" {
  default = "Demo-Template-file"
}

variable "vpc_id" {
  default = "vpc-441c3a3e"
}


