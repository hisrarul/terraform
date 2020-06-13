resource "aws_s3_bucket" "squid" {
  bucket = format("%s-%s-squid", var.name, var.account_type)
  acl    = "private"
  tags = merge(map("Name",format("%s-%s", var.name,var.squid_s3_bucket_suffix)), var.tags, var.squid_s3_bucket_tag)
}

resource "aws_s3_bucket_object" "squid_conf" {
  bucket = aws_s3_bucket.squid.id
  key    = "squid.conf"
  source = "./squid.conf"
}

resource "aws_s3_bucket_object" "whitelist_txt" {
  bucket = aws_s3_bucket.squid.id
  key    = "whitelist.txt"
  source = "./whitelist.txt"
}