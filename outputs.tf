output "bucket_name" {
  value       = aws_s3_bucket.secure_bucket.bucket
  description = "Secure S3 bucket name"
}
