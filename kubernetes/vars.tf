variable "AWS_ACCESS_KEY" {
    default =   ""
}

variable "AWS_SECRET_KEY" {
    default =   ""
}

variable "AWS_REGION" {
  default = "ap-south-1"
}

variable "PATH_TO_PUBLIC_KEY" {
    default =   "k8s-israrul-demo-key.pub"
}

variable "AMIS" {
  type = map(string)
  default = {
    ap-south-1 = "ami-01b8d0884f38e37b4"
    us-east-1 = "ami-13be557e"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-0d729a60"
  }
}

variable "name" {
    type        =   string
    default     =   "k8s"
}

variable "iam_policy_suffix" {
    type        =   string
    default     =   "iam-profile"
}

variable "k8s_master_role_suffix" {
    type        =   string
    default     =   "master-role"
}

variable "k8s_worker_role_suffix" {
    type        =   string
    default     =   "worker-role"
}

variable "k8s_ssm_policy_suffix" {
    type        =   string
    default     =   "ssm-policy"
}

variable "k8s_master_policy_suffix" {
    type        =   string
    default     =   "master-pol"
}

variable "k8s_worker_policy_suffix" {
    type        =   string
    default     =   "worker-pol"
}

variable "launch_template_suffix" {
    default     =   "lt"
    type        =   string
}

variable "master_instance_suffix" {
    default     =   "master"
}

variable "worker_instance_suffix" {
    default     =   "worker"
}

variable "INSTANCE_TYPE" {
    default     =   "t3a.small"
}

variable "tags" {
    type        =   map
    default     =   {}
}

variable "launch_template_tag" {
    default     =   {}
    type        =   map
}

variable "master_asg_suffix" {
    default     =   "master-asg"
}

variable "worker_asg_suffix" {
    default     =   "worker-asg"
}

variable "account_type" {
    default     =   "israrul-s3-demo"
}