terraform {
  backend "s3" {
    bucket         = aws_s3_bucket.k8s_s3.id
    key            = "terraform.tfstate"
    region         = var.AWS_REGION
  }
}
