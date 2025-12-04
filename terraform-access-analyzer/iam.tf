resource "aws_iam_role" "lambda_role" {
  name = "access-analyzer-evidence-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

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

resource "aws_iam_policy" "export_policy" {
  name        = "iam-access-analyzer-export-policy"
  description = "Allow Access Analyzer to export findings to S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["s3:PutObject", "s3:PutObjectAcl"]
      Resource = "${aws_s3_bucket.export_bucket.arn}/*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "export_attach" {
  role       = aws_iam_role.export_role.name
  policy_arn = aws_iam_policy.export_policy.arn
}
