resource "aws_vpc" "main" {
  cidr_block = "${var.CIDR_BLOCK}"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  tags = {
      Name = "Custom VPC"
  }
}
