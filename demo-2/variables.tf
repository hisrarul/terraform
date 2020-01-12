variable "CIDR_BLOCK" {
  description = "Enter the VPC CIDR block"
  default = "10.0.0.0/24"
}

variable "SUBNET_BLOCK1" {
  description = "Enter the first subnet block"
  default = "10.0.1.0/24"
}

variable "AZ" {
  type = "list"
  default = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
}

variable "AWS_REGION" {
  default = "us-east-1"
}


