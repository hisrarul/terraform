output "vpc_id" {
  description = "The Id of VPC"
  value = "${element(concat(aws_vpc.this.*.id,list("")),0)}"
}

output "jumphost_subnets" {
  value = "${aws_subnet.jumphost.*.id}"
}

output "k8s_master_subnets" {
  value = "${aws_subnet.k8s-master.*.id}"
}

output "k8s_worker_subnets" {
  value = "${aws_subnet.k8s-worker.*.id}"
}
output "database_subnets" {
  value = "${aws_subnet.database.*.id}"
}

output "ingress_controller_subnets" {
  value = "${aws_subnet.ingress-controller.*.id}"
}

output "db_subnet_group_name" {
  value = "${aws_db_subnet_group.database.*.id}"
}

output "nat_gateway_subnets" {
  value = "${aws_subnet.natgateway.*.id}"
}

output "private_route" {
  value = "${aws_route_table.private.*.id}"
}

output "public_route" {
  value = "${aws_route_table.public.*.id}"
}

output "jumphost_nacl" {
  value = "${aws_network_acl.jumphost.*.id}"
}

output "k8s_master_nacl" {
  value = "${aws_network_acl.k8s-master.*.id}"
}

output "k8s_worker_nacl" {
  value = "${aws_network_acl.k8s-worker.*.id}"
}

output "database_nacl" {
  value = "${aws_network_acl.database.*.id}"
}

output "natgateway_nacl" {
  value = "${aws_network_acl.natgateway.*.id}"
}