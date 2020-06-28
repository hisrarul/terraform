terraform {
  backend "s3" {
    bucket         = bucketname
    key            = "terraform.tfstate"
    region         = "ap-south-1"
  }
}
