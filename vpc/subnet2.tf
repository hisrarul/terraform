resource "aws_subnet" "subnet2" {
  cidr_block = "${var.SUBNET2CIDR}"
  availability_zone = "ap-south-1b"
  vpc_id = "${aws_vpc.ust-vpc.id}"
  tags = {
      "Name" = "${var.SUBNET2TAG}"
  }
}
