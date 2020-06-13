variable "vpc_id" {
  default     =   "vpc-123455"
  description =   "Enter the vpc id"
}

variable "name" {
  default   =   "israr"
}

variable "squid_subnets_suffix" {
  default       =   "squid"
}

variable "azs" {
  type = list
  description = "A list of availability zones in the region"
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "tags" {
  type      =   map
  default   =   {}
}

variable "squid_tags" {
  type      =   map
  default   =   {}
}

variable "squid_subnets" {
  type        =   list
  default     =   ["20.0.3.0/24", "20.0.4.0/24"]
}

variable "route_table_public" {
  default     =   "rtb-1234455"
  description =   "Enter the id of public route table"
}

variable "squid_sg_suffix" {
  type      =   string
  default   =   "squid-sg"
}

variable "squid_sg_tags" {
  type      =   map
  default   =   {}
}

variable "launch_template_suffix" {
  type      = string
  default   = "squid-lt"
}

variable "ami_id" {
  default   =   "ami-0447a12f28fddb066"
}

variable "instance_type" {
  default   =   "t2.micro"
}

variable "key_name" {
  default   =   "squid-dev"
  description = "Enter the name of existing keypair"
}

variable "instance_suffix" {
  type      = string
  default   = "squid"
}

variable "launch_template_tag" {
  type        = map
  description = "Additional tags for squid instance"
  default     = {}
}

variable "autoscaling_group_suffix" {
  type      = string
  default   = "squid-asg"
}

variable "account_type" {
  default   =   "dev"
}

variable "squid_s3_bucket_suffix" {
  default   =   "squid-config"
}

variable "squid_s3_bucket_tag" {
  default   =   {}
  type      =   map
}

variable "squid_policy_suffix" {
  default   =   "squid-instance-profile"
}

variable "squid_role_suffix" {
  default   =   "squid-role"
}

variable "squid_ssm_policy_suffix" {
  default   =   "squid-ssm-modify-instance-attribute"
}
