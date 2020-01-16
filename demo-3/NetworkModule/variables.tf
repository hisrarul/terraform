variable "name" {
  description = "Name to be used on all the resources as identifier"
  default = ""
}

variable "cidr" {
  type = "string"
  description = "The CIDR block for the VPC"
  default = ""
}

variable "instance_tenancy" {
  type = "string"
  description = "A tenancy option for instances launched into the VPC"
  default = "default"
}

variable "jumphost_subnets" {
  type = "list"
  description = "A list of public jump subnets inside the VPC"
  default = []
}

variable "jumphost_subnets_suffix" {
  type = "string"
  description = "Suffix to append to jumphost subnets name"
  default = "jumphost"
}

variable "k8s_master_subnets" {
  type = "list"
  description = "A list of kubernetes master private subnets inside the VPC"
  default = []
}

variable "ingress_controller_subnets" {
  type = "list"
  description = "A list of kubernetes ingress subnets private subnets inside the VPC"
  default = []
}

variable "k8s_master_subnets_suffix" {
  type = "string"
  description = "Suffix to append to k8s_master subnets name"
  default = "k8s-master"
}

variable "k8s_worker_subnets" {
  type = "list"
  description = "A list of kubernetes worker private subnets inside the VPC"
  default = []
}

variable "k8s_worker_subnets_suffix" {
  type = "string"
  description = "Suffix to append to k8s_worker subnets name"
  default = "k8s-worker"
}

variable "database_subnets" {
  type = "list"
  description = "A list of database subnets"
  default = []
}

variable "database_subnets_suffix" {
  type = "string"
  description = "A List of database subnets "
  default = "database"
}

variable "ingress_controller_subnets_suffix" {
  type = "string"
  description = "A List of database subnets "
  default = "ingress-controller"
}

variable "private_route_table_suffix" {
  type = "string"
  description = "Name of suffix to identify private route table"
  default = "private-rt"
}

variable "public_route_table_suffix" {
  type = "string"
  description = "Name of suffix to identify private route table"
  default = "public-rt"
}

variable "database_subnets_group_suffix" {
  type = "string"
  description = "A List of database subnets group"
  default = "database-sb-sg"
}

variable "ssh_public_source_ip" {
  type = "string"
  description = "Allow ssh access to jump host from office"
}

variable "nat_gateway_eip_suffix" {
  type = "string"
  description = "Name of suffix to identify internet gateway"
  default = "gateway-eip"
}

variable "nat_gateway_subnets_suffix" {
  type = "string"
  description = "Name of suffix to identify internet gateway"
  default = "gateway"
}

variable "nat_gateway_suffix" {
  type = "string"
  description = "Name of suffix to identify internet gateway"
  default = "gateway"
}

variable "create_database_subnet_group" {
  type = "string"
  description = "Controls if database subnet group should be created"
  default = true
}


variable "azs" {
  type = "list"
  description = "A list of availability zones in the region"
  default = []
}

variable "enable_dns_hostnames" {
  description = "Should be true if you want to use private DNS within the VPC"
  default = false
}

variable "enable_dns_support" {
  description = "Should be true if you want to use private DNS within the VPC"
  default = false
}

variable "enable_nat_gateway" {
  type = "string"
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  default = false
}

variable "single_nat_gateway" {
  type = "string"
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  default = false
}

variable "nat_gateway_subnets" {
  type = "list"
  description = "A list of kubernetes worker private subnets inside the VPC"
  default = []
}

variable "enable_s3_endpoint" {
  type = "string"
  description = "Should be true if you want to provision an S3 endpoint to the VPC"
  default = false
}

variable "map_public_ip_on_launch" {
  type = "string"
  description = "Should be false if you do not want to auto-assign public IP on launch"
  default = true
}

variable "private_propagating_vgws" {
  type = "list"
  description = "A list of VGWs the private route table should propagate"
  default = []
}

variable "public_propagating_vgws" {
  type = "list"
  description = "A list of VGWs the public route table should propagate"
  default = []
}

variable "tags" {
  type = "map"
  description = "A map of tags to add to all resources"
  default = {}
}

variable "public_subnet_tags" {
  type = "map"
  description = "Additional tags for the public subnets"
  default = {}
}

variable "private_subnet_tags" {
  type = "map"
  description = "Additional tags for the private subnets"
  default = {}
}

variable "public_route_table_tags" {
  type = "map"
  description = "Additional tags for the public route tables"
  default = {}
}

variable "private_route_table_tags" {
  type = "map"
  description = "Additional tags for the private route tables"
  default = {}
}


variable "nat_gateway_eip_tags" {
  type = "map"
  description = "Additional tags for the natgatway eip"
  default = {}
}

variable "nat_gateway_tags" {
  type = "map"
  description = "Additional tags for the natgatway eip"
  default = {}
}



variable "nat_gateway_subnet_tags" {
  type = "map"
  description = "Additional tags for the natgatway eip"
  default = {}
}

variable "ingress_controller_subnet_tags" {
  type = "map"
  description = "Additional tags for the ingress controller tags"
  default = {}
}

variable "jumphost_tags" {
  type = "map"
  description = "Additional tags for the natgatway eip"
  default = {}
}

variable "k8s_master_tags" {
  type = "map"
  description = "Additional tags for the natgatway eip"
  default = {}
}

variable "k8s_worker_tags" {
  type = "map"
  description = "Additional tags for the natgatway eip"
  default = {}
}

variable "database_tags" {
  type = "map"
  description = "Additional tags for the database subnets"
  default = {}
}
#### NACL Name suffix
variable "jumphost_nacl_suffix" {
  type = "string"
  description = "Jump Host Nacl suffix"
  default = "Jumphost-Nacl"
}

variable "k8s_master_nacl_suffix" {
  type = "string"
  description = "Jump Host Nacl suffix"
  default = "K8S-Master-Nacl"
}


variable "k8s_worker_nacl_suffix" {
  type = "string"
  description = "Jump Host Nacl suffix"
  default = "K8S-Worker-Nacl"
}

variable "database_nacl_suffix" {
  type = "string"
  description = "Jump Host Nacl suffix"
  default = "Database-Nacl"
}

variable "natgateway_nacl_suffix" {
  type = "string"
  description = "Jump Host Nacl suffix"
  default = "NatGateway-Nacl"
}
