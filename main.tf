# Create an S3 bucket
resource "aws_s3_bucket" "lb_s3_bucket" {
  bucket = "lb-s3-webstatic-bucket-631737274131"
  tags = {
    Name        = "S3 Static Website"
    Environment = "Production"
  }
 } 

 resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.lb_s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# AWS S3 bucket ACL resource
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.lb_s3_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.lb_s3_bucket.id
  versioning_configuration { 
    status = "Enabled"
  }
}

# Separate the website configuration for the S3 bucket
resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.lb_s3_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}


# Disable Block Public Access for the S3 bucket
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.lb_s3_bucket.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}

# Configure the bucket policy to allow public access to the website content

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.lb_s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.lb_s3_bucket.arn}/*"
      }
    ]
  })
}

# Upload the index.html file to the S3 bucket
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.lb_s3_bucket.bucket
  key    = "index.html"
  source = "index.html"  # Provide the path to your local index.html file
  acl = "public-read"
}

# Upload the error.html file to the S3 bucket
resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.lb_s3_bucket.bucket
  key    = "error.html"
  source = "error.html"  # Provide the path to your local error.html file
  acl = "public-read"
 }

output "website_url" {
  value = aws_s3_bucket_website_configuration.example.website_endpoint
}