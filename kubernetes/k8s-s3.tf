resource "aws_s3_bucket" "k8s_s3" {
  bucket = format("%s-%s", var.name, var.account_type)
  acl    = "private"
  force_destroy = true
  tags = {
    "kubernetes.io/cluster/k8s-israrul-demo"    =   "owned"
  }
}