data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

data "template_file" "user_data" {
template = "${file("user_data.sh.tpl")}"
vars {
    packages = "${var.extra_packages}"
    nameserver = "${var.external_nameserver}"
}
}

data "aws_vpc" "main" {
  id = "${var.vpc_id}"
}


resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = "${data.aws_vpc.main.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app-server" {
ami = "${data.aws_ami.ubuntu.id}"
instance_type = "${lookup(var.INSTANCE_TYPE, var.ENV)}"
subnet_id = "${var.SUBNET_ID}"
vpc_security_group_ids = ["${concat(var.EXTRA_SGS, aws_security_group.allow_http.*.id)}"]
user_data = "${data.template_file.user_data.rendered}"
key_name = "israrulkey-testaccount"
tags {
Name = "${var.NAME}"
}
}