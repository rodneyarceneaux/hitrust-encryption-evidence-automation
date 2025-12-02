resource "aws_cloudwatch_event_rule" "daily_export" {
  name                = "iam-analyzer-daily-export"
  schedule_expression = "cron(0 2 * * ? *)" # 2AM UTC
}

resource "aws_cloudwatch_event_target" "export_target" {
  rule      = aws_cloudwatch_event_rule.daily_export.name
  arn       = "arn:aws:access-analyzer:${var.region}:${data.aws_caller_identity.current.account_id}:analyzer/access-analyzer-org"
  input     = jsonencode({
    "exportDestination" : {
      "s3" : {
        "bucket" : aws_s3_bucket.export_bucket.bucket
      }
    }
  })
}
