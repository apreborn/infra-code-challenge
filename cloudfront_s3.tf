# S3 Bucket for Static Website Hosting
resource "aws_s3_bucket" "static_website" {
  bucket        = var.bucket_name
  website {
    index_document = "index.html"
  }

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Upload static HTML file to S3
resource "aws_s3_object" "index" {
  bucket        = aws_s3_bucket.static_website.id
  key           = "index.html"
  source        = "index.html"
  content_type  = "text/html"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.static_website.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.static_website.bucket
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.static_website.bucket
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = var.tags
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "s3-cloudfront-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_iam_policy_document" "cloudfront_oac_access" {
  statement {

    actions = [
      "s3:GetObject"
    ]
    resources = ["${aws_s3_bucket.static_website.arn}/*"]
    
  }
}

resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.static_website.id
  policy = data.aws_iam_policy_document.cloudfront_oac_access.json
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

output "bucket_arn" {
  value = aws_s3_bucket.static_website.arn
}
