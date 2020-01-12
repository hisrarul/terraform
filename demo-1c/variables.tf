variable "AMIS" {
  type = "map"
  default = {
    us-east-1 = "ami-09f9d773751b9d606"
  }
}
variable "KEYNAME" {
  default = "israrulkey"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "israrulkey"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "israrulkey.pub"
}
variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}

variable "AWS_REGION" {
  default = "us-east-1"
}
