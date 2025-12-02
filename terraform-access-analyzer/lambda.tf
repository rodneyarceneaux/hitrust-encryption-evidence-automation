data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda.zip"
  source {
    content  = file("${path.module}/index.py")
    filename = "index.py"
  }
}

resource "aws_lambda_function" "evidence_export" {
  function_name = "iam-access-analyzer-evidence-export"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      EVIDENCE_BUCKET = aws_s3_bucket.export_bucket.bucket
      ACCOUNT_ID      = data.aws_caller_identity.current.account_id
      ANALYZER_NAME   = aws_accessanalyzer_analyzer.org_analyzer.analyzer_name
    }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_attach]
}
