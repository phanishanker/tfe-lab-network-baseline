##################################
# Default Tags for Governance
##################################
locals {
  default_tags = {
    Owner       = "platform-team"
    CostCenter  = "CLOUD-PLATFORM"
    Environment = var.environment
    ManagedBy   = "Terraform-Enterprise"
    Project     = "tfe-lab-1"
  }
}

##################################
# Random suffix for S3 bucket name
##################################
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

##################################
# Secure S3 Bucket Definition
##################################
resource "aws_s3_bucket" "secure_bucket" {
  bucket = "acme-${var.environment}-${random_string.suffix.result}"
  tags   = local.default_tags
}

##################################
# Enable Versioning
##################################
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.secure_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

##################################
# Block Public Access
##################################
resource "aws_s3_bucket_public_access_block" "secure_block" {
  bucket                  = aws_s3_bucket.secure_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

##################################
# Enforce Default Encryption
##################################
resource "aws_s3_bucket_server_side_encryption_configuration" "secure_encrypt" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

##################################
# Enforce HTTPS Only Access
##################################
resource "aws_s3_bucket_policy" "https_only" {
  bucket = aws_s3_bucket.secure_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid:       "EnforceTLS",
        Effect:    "Deny",
        Principal: "*",
        Action:    "s3:*",
        Resource: [
          aws_s3_bucket.secure_bucket.arn,
          "${aws_s3_bucket.secure_bucket.arn}/*"
        ],
        Condition: {
          Bool: {
            "aws:SecureTransport": "false"
          }
        }
      }
    ]
  })
}
