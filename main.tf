# Create an S3 bucket
resource "aws_s3_bucket" "lb_s3_bucket" {
  bucket = "lb-s3-bucket-acm-631737274131"
  
}

# Disable Block Public Access for the S3 bucket
resource "aws_s3_bucket_public_access_block" "lb_s3_bucket_public_access_block" {
  bucket = aws_s3_bucket.lb_s3_bucket.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}