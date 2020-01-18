resource "aws_route_table_association" "publicrouteassociation" {
  subnet_id = "${aws_subnet.subnet1.id}"
  route_table_id = "${aws_route_table.publicroutetable.id}"
}

resource "aws_route_table_association" "privaterouteassociation" {
  subnet_id = "${aws_subnet.subnet2.id}"
  route_table_id = "${aws_route_table.privateroutetable.id}"
}