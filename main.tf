locals {
  default_tags = {
    Owner       = "platform-team"
    CostCenter  = "CLOUD-PLATFORM"
    Environment = "lab"
    ManagedBy   = "Terraform-Enterprise"
    Project     = "tfe-lab-1"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "secure_bucket" {
  bucket = "acme-tfe-lab1-${var.aws_region}-${random_id.suffix.hex}"
  tags   = local.default_tags
}
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.secure_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
//
