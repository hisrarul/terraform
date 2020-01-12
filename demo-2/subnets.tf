resource "aws_subnet" "main" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.CIDR_BLOCK}"
  availability_zone = "${var.AZ[0]}"

  tags = {
    Name = "Subnet1"
  }
}