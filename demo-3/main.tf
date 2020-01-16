provider "aws" {
  region = "us-east-1"
  version = "~> 2.19.0"
}
variable "name" {
  type = "string"
}
variable "ssh_allow_ipaddress" {
  type = "string"
}

module "vpc" {
  source = "NetworkModule"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
  name = "${var.name}"
  cidr = "192.168.0.0/16"

  azs = [
    "us-east-1a",
    "us-east-1b"]

  k8s_master_subnets = [
    "192.168.3.0/24",
    "192.168.4.0/24"]
  k8s_worker_subnets = [
    "192.168.5.0/24",
    "192.168.6.0/24"]
  database_subnets = [
    "192.168.7.0/24",
    "192.168.8.0/24"]
  jumphost_subnets = [
    "192.168.1.0/24",
    "192.168.2.0/24"]
  nat_gateway_subnets = [
    "192.168.9.0/24"]
  ingress_controller_subnets = [
    "192.168.10.0/24",
    "192.168.11.0/24"
  ]

  ingress_controller_subnet_tags = {
    "KubernetesCluster" = "kubernetes"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }

  public_route_table_tags = {
    "KubernetesCluster" = "kubernetes"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }

  enable_nat_gateway = "true"
  ssh_public_source_ip = "${var.ssh_allow_ipaddress}"
  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}