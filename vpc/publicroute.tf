resource "aws_route_table" "publicroutetable" {
  vpc_id = "${aws_vpc.ust-vpc.id}"
  tags = {
      "Name" = "pub-RT"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
}
