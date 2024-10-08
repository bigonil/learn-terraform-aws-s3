# S3 bucket resource with website configuration and versioning
resource "aws_s3_bucket" "lb_s3_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "S3 Static Website"
    Environment = var.environment
  }

  website {
    index_document = var.index_document
    error_document = var.error_document
  }
}

# Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "lb_s3_bucket_versioning" {
  bucket = aws_s3_bucket.lb_s3_bucket.id
  
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

# Disable Block Public Access for the S3 bucket
resource "aws_s3_bucket_public_access_block" "lb_s3_bucket_public_access_block" {
  bucket = aws_s3_bucket.lb_s3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Bucket policy to allow CloudFront to access S3 content
resource "aws_s3_bucket_policy" "lb_s3_static_website_policy" {
  bucket = aws_s3_bucket.lb_s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          "Service": "cloudfront.amazonaws.com"
        },
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.lb_s3_bucket.arn}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.lb_cloudfront.arn
          }
        }
      }
    ]
  })
}

# CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "lb_s3_oac" {
  name                          = "s3-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior              = "always"
  signing_protocol              = "sigv4"
}

# CloudFront Distribution for S3 static website
resource "aws_cloudfront_distribution" "lb_cloudfront" {
  origin {
    domain_name               = aws_s3_bucket.lb_s3_bucket.bucket_regional_domain_name
    origin_id                 = aws_s3_bucket.lb_s3_bucket.id
    origin_access_control_id  = aws_cloudfront_origin_access_control.lb_s3_oac.id
  }

  enabled = true
  is_ipv6_enabled = true

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.lb_s3_bucket.id

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_root_object = var.index_document
}

# Upload the index.html file to the S3 bucket
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.lb_s3_bucket.bucket
  key    = var.index_document
  source = var.index_html_source
}

# Upload the error.html file to the S3 bucket
resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.lb_s3_bucket.bucket
  key    = var.error_document
  source = var.error_html_source
}