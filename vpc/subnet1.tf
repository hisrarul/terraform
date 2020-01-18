resource "aws_subnet" "subnet1" {
  cidr_block = "${var.SUBNET1CIDR}"
  availability_zone = "ap-south-1a"
  vpc_id = "${aws_vpc.ust-vpc.id}"
  tags = {
      "Name" = "${var.SUBNET1TAG}"
  }
}
