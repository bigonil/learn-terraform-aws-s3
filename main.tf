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

# Optionally, add a bucket policy (for specific permissions)
resource "aws_s3_bucket_policy" "lb_s3_bucket_policy" {
  bucket = aws_s3_bucket.lb_s3_bucket.id
  policy = jsonencode({ Statement = [{ Effect = "Allow", Principal = "*", Action = ["s3:GetObject"], Resource = ["arn:aws:s3:::lb-s3-bucket-acm/*"] }] })
}
