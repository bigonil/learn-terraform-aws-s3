# Create an S3 bucket
resource "aws_s3_bucket" "lb_s3_bucket" {
  bucket = "lb-s3-bucket-acm" # Replace with your bucket name
}

# Optionally, add a bucket policy (for specific permissions)
resource "aws_s3_bucket_policy" "lb_s3_bucket_policy" {
  bucket = aws_s3_bucket.lb_s3_bucket.id
  policy = jsonencode({ Statement = [{ Effect = "Allow", Principal = "*", Action = ["s3:GetObject"], Resource = ["arn:aws:s3:::lb-s3-bucket-acm/*"] }] })
}
