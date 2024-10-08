# Output the S3 website URL (constructing it manually)
output "s3_website_url" {
  value = "http://${aws_s3_bucket.lb_s3_bucket.bucket_regional_domain_name}/"
  description = "The URL for the S3 static website"
}

# Output the CloudFront distribution domain name
output "cloudfront_url" {
  value       = aws_cloudfront_distribution.lb_cloudfront.domain_name
  description = "The URL for the CloudFront distribution"
}
