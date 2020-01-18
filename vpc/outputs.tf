output "igw-id" {
  description = "Id of the IGW"
  value = "${aws_internet_gateway.igw.id}"
}
