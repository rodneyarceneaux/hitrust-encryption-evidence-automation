resource "aws_s3_bucket" "export_bucket" {
  bucket = "access-analyzer-evidence-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_public_access_block" "export_block" {
  bucket = aws_s3_bucket.export_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "export_versioning" {
  bucket = aws_s3_bucket.export_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.export_bucket.id

  rule {
    id     = "cleanup"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = 30
    }
  }
}
