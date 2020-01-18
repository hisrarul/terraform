resource "aws_route_table" "privateroutetable" {
  vpc_id = "${aws_vpc.ust-vpc.id}"
  tags = {
      "Name" = "prv-RT"
  }
}
