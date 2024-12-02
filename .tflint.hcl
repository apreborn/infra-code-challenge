plugin "aws" {
  enabled = true
  region  = var.region
}

rule "aws_s3_bucket_public_acl" {
  enabled = true
}
