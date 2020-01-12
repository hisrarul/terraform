provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ubuntu-web-server" {
    ami = "ami-09f9d773751b9d606"
    instance_type = "t2.micro"
    key_name = "${var.keyname}"
}

variable "keyname" {
  
}


