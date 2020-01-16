######
# VPC
######
resource "aws_vpc" "this" {
  cidr_block = "${var.cidr}"
  instance_tenancy = "${var.instance_tenancy}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support = "${var.enable_dns_support}"

  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

###################
# Internet Gateway
###################
resource "aws_internet_gateway" "this" {
  vpc_id = "${aws_vpc.this.id}"
  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

################
#  Subnets
################
resource "aws_subnet" "jumphost" {
  count = "${length(var.jumphost_subnets) > 0 ? length(var.jumphost_subnets) : 0 }"
  cidr_block = "${var.jumphost_subnets[count.index]}"
  vpc_id = "${aws_vpc.this.id}"
  tags = "${merge(map("Name", format("%s-%s-%s", var.name, var.jumphost_subnets_suffix, element(var.azs, count.index))), var.tags, var.jumphost_tags)}"
}


resource "aws_subnet" "k8s-master" {
  count = "${length(var.k8s_master_subnets) > 0 ? length(var.k8s_master_subnets) : 0 }"
  cidr_block = "${var.k8s_master_subnets[count.index]}"
  availability_zone = "${var.azs[count.index]}"
  vpc_id = "${aws_vpc.this.id}"
  tags = "${merge(map("Name", format("%s-%s-%s", var.name, var.k8s_master_subnets_suffix, element(var.azs, count.index))), var.tags, var.k8s_master_tags)}"
}

resource "aws_subnet" "k8s-worker" {
  count = "${length(var.k8s_worker_subnets) > 0 ? length(var.k8s_worker_subnets) : 0 }"

  cidr_block = "${var.k8s_worker_subnets[count.index]}"

  availability_zone = "${element(var.azs, count.index)}"

  vpc_id = "${aws_vpc.this.id}"
  tags = "${merge(map("Name", format("%s-%s-%s", var.name, var.k8s_worker_subnets_suffix, element(var.azs, count.index))), var.tags, var.k8s_worker_tags)}"
}


resource "aws_subnet" "ingress-controller" {
  count = "${length(var.ingress_controller_subnets) > 0 ? length(var.ingress_controller_subnets) : 0 }"

  cidr_block = "${var.ingress_controller_subnets[count.index]}"

  availability_zone = "${element(var.azs, count.index)}"

  vpc_id = "${aws_vpc.this.id}"
  tags = "${merge(map("Name", format("%s-%s-%s", var.name, var.ingress_controller_subnets_suffix, element(var.azs, count.index))), var.tags, var.ingress_controller_subnet_tags)}"
}

#########################################
# Database Subnets
#########################################

resource "aws_subnet" "database" {

  count = "${length(var.database_subnets) > 0 ? length(var.database_subnets) : 0 }"

  cidr_block = "${element(var.database_subnets, count.index)}"

  availability_zone = "${element(var.azs, count.index)}"

  vpc_id = "${aws_vpc.this.id}"
  tags = "${merge(map("Name", format("%s-%s-%s", var.name, var.database_subnets_suffix, element(var.azs, count.index))), var.tags, var.database_tags)}"
}

resource "aws_db_subnet_group" "database" {
  count = "${length(var.database_subnets) > 0 && var.create_database_subnet_group ? 1 : 0 }"

  name = "${lower(var.name)}"

  description = "Database Subnet Group for ${var.name}"

  subnet_ids = [
    "${aws_subnet.database.*.id}"]

  tags = "${merge(map("Name", format("%s-%s-%s", var.name, var.database_subnets_group_suffix, element(var.azs, count.index))), var.tags, var.database_tags)}"
}

################################################
# Route Table
###################################################

resource "aws_route_table" "private" {
  count = "${length(var.k8s_master_subnets) > 0 && length(var.k8s_worker_subnets) > 0 && length(var.database_subnets) > 0 ? 1 : 0}"

  vpc_id = "${aws_vpc.this.id}"

  tags = "${merge(map("Name",format("%s-%s", var.name,var.private_route_table_suffix)), var.tags, var.private_route_table_tags)}"
}

resource "aws_route_table" "public" {
  count = "${length(var.jumphost_subnets) > 0 ? 1 : 0}"

  vpc_id = "${aws_vpc.this.id}"

  tags = "${merge(map("Name",format("%s-%s",var.name, var.public_route_table_suffix)), var.tags, var.public_route_table_tags)}"

}


##########################################
# Route Table Association
##########################################
resource "aws_route_table_association" "k8s-master" {
  count = "${length(var.k8s_master_subnets) > 0 ? length(var.k8s_master_subnets) : 0}"
  route_table_id = "${aws_route_table.private.id}"
  subnet_id = "${element(aws_subnet.k8s-master.*.id, count.index)}"
}

resource "aws_route_table_association" "k8s-worker" {
  count = "${length(var.k8s_worker_subnets) > 0 ? length(var.k8s_worker_subnets) : 0}"
  route_table_id = "${aws_route_table.private.id}"
  subnet_id = "${element(aws_subnet.k8s-worker.*.id,count.index)}"
}

resource "aws_route_table_association" "database" {
  count = "${length(var.database_subnets) > 0 ? length(var.database_subnets) : 0}"
  route_table_id = "${aws_route_table.private.id}"
  subnet_id = "${element(aws_subnet.database.*.id,count.index)}"
}

resource "aws_route_table_association" "jumphost" {
  count = "${length(var.jumphost_subnets) > 0 ? length(var.jumphost_subnets) : 0}"
  route_table_id = "${aws_route_table.public.id}"
  subnet_id = "${element(aws_subnet.jumphost.*.id, count.index)}"
}

resource "aws_route_table_association" "natgateway" {
  count = "${length(var.nat_gateway_subnets) > 0 ? length(var.nat_gateway_subnets) : 0}"
  route_table_id = "${aws_route_table.public.id}"
  subnet_id = "${element(aws_subnet.natgateway.*.id, count.index)}"
}

resource "aws_route_table_association" "ingress-controller" {
  count = "${length(var.ingress_controller_subnets) > 0 ? length(var.ingress_controller_subnets) : 0}"
  route_table_id = "${aws_route_table.public.id}"
  subnet_id = "${element(aws_subnet.ingress-controller.*.id, count.index)}"
}

##############################################
# Nat GateWay Configure
################################################

resource "aws_subnet" "natgateway" {
  count = "${length(var.nat_gateway_subnets) > 0 ? length(var.nat_gateway_subnets) : 0}"
  cidr_block = "${element(var.nat_gateway_subnets, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"
  vpc_id = "${aws_vpc.this.id}"
  tags = "${merge(map("Name",format("%s-%s-%s", var.name,var.nat_gateway_subnets_suffix, element(var.azs, count.index))), var.tags, var.nat_gateway_subnet_tags)}"
}

resource "aws_eip" "nat" {
  count = "${length(var.nat_gateway_subnets) > 0 && var.enable_nat_gateway ? 1 : 0 }"
  vpc = true
  tags = "${merge(map("Name",format("%s-%s-%s", var.name,var.nat_gateway_eip_suffix, element(var.azs, count.index))), var.tags, var.nat_gateway_eip_tags)}"
}
resource "aws_nat_gateway" "gateway" {
  count = "${length(var.nat_gateway_subnets) > 0 && var.enable_nat_gateway ? 1 : 0 }"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id = "${element(aws_subnet.natgateway.*.id, count.index)}"
  depends_on = [
    "aws_internet_gateway.this"]
  tags = "${merge(map("Name",format("%s-%s-%s", var.name,var.nat_gateway_suffix, element(var.azs, count.index))), var.tags, var.nat_gateway_tags)}"

}

##############################################
# AWS Route Table Configuration
#################################################

resource "aws_route" "public" {
  count = "${length(var.jumphost_subnets) > 0 ? 1 : 0}"
  route_table_id = "${element(aws_route_table.public.*.id,count.index)}"

  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.this.id}"

  timeouts {
    create = "5m"
  }

}

resource "aws_route" "private" {
  count = "${length(var.nat_gateway_subnets) > 0 && var.enable_nat_gateway ? 1 : 0 }"
  route_table_id = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.gateway.id}"

  timeouts {
    create = "5m"
  }
}


#####################################################
# NACL
####################################################

resource "aws_network_acl" "jumphost" {
  count = "${length(var.jumphost_subnets) > 0 ? 1 : 0}"

  vpc_id = "${aws_vpc.this.id}"
  subnet_ids = [
    "${aws_subnet.jumphost.*.id}"]

  tags = "${merge(map("Name",format("%s-%s", var.name,var.jumphost_nacl_suffix)), var.tags, var.jumphost_tags)}"

  # allow ssh from office address
  ingress {
    action = "allow"
    from_port = 22
    protocol = "tcp"
    rule_no = 100
    to_port = 22
    cidr_block = "${var.ssh_public_source_ip}"
  }

  egress {
    action = "allow"
    from_port = 1024
    protocol = "tcp"
    rule_no = 100
    to_port = 65535
    cidr_block = "${var.ssh_public_source_ip}"
  }

  # Allow Internet Access
  ingress {
    action = "allow"
    from_port = 1024
    protocol = "tcp"
    rule_no = 110
    to_port = 65535
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action = "allow"
    from_port = 80
    protocol = "tcp"
    rule_no = 110
    to_port = 80
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action = "allow"
    from_port = 443
    protocol = "tcp"
    rule_no = 120
    to_port = 443
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action = "allow"
    from_port = 22
    protocol = "tcp"
    rule_no = 130
    to_port = 22
    cidr_block = "${var.cidr}"
  }

  ingress {
    action = "allow"
    from_port = 1024
    protocol = "udp"
    rule_no = 120
    to_port = 65535
    cidr_block = "${var.cidr}"
  }

  egress {
    action = "allow"
    from_port = 1514
    protocol = "udp"
    rule_no = 140
    to_port = 1514
    cidr_block = "${var.cidr}"
  }

  egress {
    action = "allow"
    from_port = 22
    protocol = "tcp"
    rule_no = 150
    to_port = 22
    cidr_block = "${var.cidr}"
  }


}
########################## K8s Master Rules #######################################
resource "aws_network_acl" "k8s-master" {
  count = "${length(var.k8s_master_subnets) > 0 ? 1 : 0}"

  vpc_id = "${aws_vpc.this.id}"
  subnet_ids = [
    "${aws_subnet.k8s-master.*.id}"]

  tags = "${merge(map("Name",format("%s-%s", var.name,var.k8s_master_nacl_suffix)), var.tags, var.k8s_master_tags)}"
}

resource "aws_network_acl_rule" "ingress-k8s-master-jumphost" {
  count = "${length(var.jumphost_subnets) > 0 && length(var.k8s_master_subnets) > 0 ? length(var.jumphost_subnets) :  0}"
  network_acl_id = "${aws_network_acl.k8s-master.id}"
  protocol = "tcp"
  from_port = 22
  to_port = 22
  egress = false
  rule_action = "allow"
  rule_number = "${ 200 + count.index }"
  cidr_block = "${element(var.jumphost_subnets,count.index)}"
}

resource "aws_network_acl_rule" "ingress-k8s-master-internet-access" {
  count = "${length(var.k8s_master_subnets) > 0 ? 1 :  0}"
  network_acl_id = "${aws_network_acl.k8s-master.id}"
  protocol = "tcp"
  from_port = 1024
  to_port = 65535
  egress = false
  rule_action = "allow"
  rule_number = "100"
  cidr_block = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "egress-k8s-master-internet-access-over-http" {
  count = "${length(var.k8s_master_subnets) > 0 ? 1 :  0}"
  network_acl_id = "${aws_network_acl.k8s-master.id}"
  protocol = "tcp"
  from_port = 80
  to_port = 80
  egress = true
  rule_action = "allow"
  rule_number = "101"
  cidr_block = "0.0.0.0/0"
}


resource "aws_network_acl_rule" "egress-k8s-master-internet-access-over-https" {
  count = "${length(var.k8s_master_subnets) > 0 ? 1 :  0}"
  network_acl_id = "${aws_network_acl.k8s-master.id}"
  protocol = "tcp"
  from_port = 443
  to_port = 443
  egress = true
  rule_action = "allow"
  rule_number = "102"
  cidr_block = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "ingress-k8s-master-k8s-worker" {
  count = "${length(var.k8s_worker_subnets) > 0 ? length(var.k8s_worker_subnets) :  0}"
  network_acl_id = "${aws_network_acl.k8s-master.id}"
  protocol = "tcp"
  rule_action = "allow"
  from_port = 0
  to_port = 65535
  egress = false
  rule_number = "${ 202 + count.index }"
  cidr_block = "${element(var.k8s_worker_subnets,count.index)}"
}

resource "aws_network_acl_rule" "egress-k8s-master-k8s-worker" {
  count = "${length(var.k8s_worker_subnets) > 0 ? length(var.k8s_worker_subnets) :  0}"
  network_acl_id = "${aws_network_acl.k8s-master.id}"
  protocol = "tcp"
  rule_action = "allow"
  from_port = 0
  to_port = 65535
  egress = true
  rule_number = "${ 202 + count.index }"
  cidr_block = "${element(var.k8s_worker_subnets,count.index)}"
}

resource "aws_network_acl_rule" "egress-k8s-master-k8s-jumphost" {
  count = "${length(var.jumphost_subnets) > 0 ? length(var.jumphost_subnets) :  0}"
  network_acl_id = "${aws_network_acl.k8s-master.id}"
  protocol = "tcp"
  rule_action = "allow"
  from_port = 1024
  to_port = 65535
  egress = true
  rule_number = "${ 300 + count.index }"
  cidr_block = "${element(var.jumphost_subnets,count.index)}"
}


########################K8s-Worker Rules########################
resource "aws_network_acl" "k8s-worker" {
  count = "${length(var.k8s_worker_subnets) > 0 ? 1 : 0}"

  vpc_id = "${aws_vpc.this.id}"
  subnet_ids = [
    "${aws_subnet.k8s-worker.*.id}"]

  tags = "${merge(map("Name",format("%s-%s", var.name,var.k8s_worker_nacl_suffix)), var.tags, var.k8s_worker_tags)}"

}


resource "aws_network_acl_rule" "ingress-k8s-worker-jumphost" {
  count = "${length(var.jumphost_subnets) > 0 ? length(var.jumphost_subnets) :  0}"
  network_acl_id = "${aws_network_acl.k8s-worker.id}"
  protocol = "tcp"
  from_port = 22
  to_port = 22
  egress = false
  rule_action = "allow"
  rule_number = "${ 200 + count.index }"
  cidr_block = "${element(var.jumphost_subnets,count.index)}"
}



resource "aws_network_acl_rule" "ingress-k8s-worker-k8s-master" {
  count = "${length(var.k8s_master_subnets) > 0 ? length(var.k8s_master_subnets) :  0}"
  network_acl_id = "${aws_network_acl.k8s-worker.id}"
  protocol = "tcp"
  rule_action = "allow"
  from_port = 0
  to_port = 65535
  rule_number = "${ 202 + count.index }"
  cidr_block = "${element(var.k8s_master_subnets,count.index)}"
}


resource "aws_network_acl_rule" "egress-k8s-worker-k8s-master" {
  count = "${length(var.k8s_master_subnets) > 0 ? length(var.k8s_master_subnets) :  0}"
  network_acl_id = "${aws_network_acl.k8s-worker.id}"
  protocol = "tcp"
  rule_action = "allow"
  from_port = 0
  to_port = 65535
  egress = true
  rule_number = "${ 202 + count.index }"
  cidr_block = "${element(var.k8s_master_subnets,count.index)}"
}


resource "aws_network_acl_rule" "ingress-k8s-worker-internet-access" {
  count = "${length(var.k8s_worker_subnets) > 0 ? 1 :  0}"
  network_acl_id = "${aws_network_acl.k8s-worker.id}"
  protocol = "tcp"
  from_port = 1024
  to_port = 65535
  egress = false
  rule_action = "allow"
  rule_number = "100"
  cidr_block = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "egress-k8s-worker-internet-access-over-http" {
  count = "${length(var.k8s_worker_subnets) > 0 ? 1 :  0}"
  network_acl_id = "${aws_network_acl.k8s-worker.id}"
  protocol = "tcp"
  from_port = 80
  to_port = 80
  egress = true
  rule_action = "allow"
  rule_number = "101"
  cidr_block = "0.0.0.0/0"
}


resource "aws_network_acl_rule" "egress-k8s-worker-internet-access-over-https" {
  count = "${length(var.k8s_worker_subnets) > 0 ? 1 :  0}"
  network_acl_id = "${aws_network_acl.k8s-worker.id}"
  protocol = "tcp"
  from_port = 443
  to_port = 443
  egress = true
  rule_action = "allow"
  rule_number = "102"
  cidr_block = "0.0.0.0/0"
}


resource "aws_network_acl_rule" "egress-k8s-worker-k8s-jumphost" {
  count = "${length(var.jumphost_subnets) > 0 ? length(var.jumphost_subnets) :  0}"
  network_acl_id = "${aws_network_acl.k8s-worker.id}"
  protocol = "tcp"
  rule_action = "allow"
  from_port = 1024
  to_port = 65535
  egress = true
  rule_number = "${ 300 + count.index }"
  cidr_block = "${element(var.jumphost_subnets,count.index)}"
}

#######################Database Configuration ##################################
resource "aws_network_acl" "database" {
  count = "${length(var.database_subnets) > 0 ? 1 : 0}"

  vpc_id = "${aws_vpc.this.id}"
  subnet_ids = [
    "${aws_subnet.database.*.id}"]

  tags = "${merge(map("Name",format("%s-%s", var.name,var.database_nacl_suffix)), var.tags, var.database_tags)}"

  egress {
    action = "allow"
    from_port = 1024
    protocol = "tcp"
    rule_no = 100
    to_port = 65535
    cidr_block = "${var.cidr}"
  }

}

resource "aws_network_acl_rule" "ingress-database-k8s-worker" {
  count = "${length(var.k8s_worker_subnets) > 0 ? length(var.k8s_worker_subnets) :  0}"
  network_acl_id = "${aws_network_acl.database.id}"
  protocol = "tcp"
  rule_action = "allow"
  from_port = 3306
  to_port = 3306
  egress = false
  rule_number = "${ 202 + count.index }"
  cidr_block = "${element(var.k8s_worker_subnets,count.index)}"
}

resource "aws_network_acl" "natgateway" {
  count = "${length(var.nat_gateway_subnets) > 0 ? 1 : 0}"

  vpc_id = "${aws_vpc.this.id}"
  subnet_ids = [
    "${aws_subnet.natgateway.*.id}"]

  tags = "${merge(map("Name",format("%s-%s", var.name,var.natgateway_nacl_suffix)), var.tags, var.nat_gateway_tags)}"

  ingress {
    action = "allow"
    from_port = 1024
    protocol = "tcp"
    rule_no = 100
    to_port = 65535
    cidr_block = "0.0.0.0/0"
  }
  ingress {
    action = "allow"
    from_port = 443
    protocol = "tcp"
    rule_no = 110
    to_port = 443
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    action = "allow"
    from_port = 80
    protocol = "tcp"
    rule_no = 120
    to_port = 80
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action = "allow"
    from_port = 1024
    protocol = "tcp"
    rule_no = 100
    to_port = 65535
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action = "allow"
    from_port = 443
    protocol = "tcp"
    rule_no = 110
    to_port = 443
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action = "allow"
    from_port = 80
    protocol = "tcp"
    rule_no = 120
    to_port = 80
    cidr_block = "0.0.0.0/0"
  }
}