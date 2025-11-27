locals {
  default_tags = {
    Owner       = "platform-team"
    CostCenter  = "CLOUD-PLATFORM"
    Environment = var.environment
    ManagedBy   = "Terraform-Enterprise"
    Project     = "tfe-lab-1"
  }
}

resource "random_string" "suffix" {
  length  = 6
  special = false
}

resource "aws_s3_bucket" "secure_bucket" {
  bucket = "acme-${var.environment}-${random_string.suffix.result}"
  tags   = local.default_tags
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.secure_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
