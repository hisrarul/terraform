resource "aws_vpc" "ust-vpc" {
  cidr_block = "${var.VPCCIDR}"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
      Name = "${var.VPCTAG}"
    }
}
