resource "aws_iam_role" "export_role" {
  name = "iam-access-analyzer-export-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "access-analyzer.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "export_policy" {
  name = "iam-access-analyzer-export-policy"
  role = aws_iam_role.export_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:PutObject",
        "s3:GetBucketLocation"
      ]
      Resource = [
        "${aws_s3_bucket.export_bucket.arn}/*"
      ]
    }]
  })
}
