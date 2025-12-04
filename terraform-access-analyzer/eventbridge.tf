resource "aws_cloudwatch_event_rule" "daily_export" {
  name                = "iam-analyzer-daily-export"
  description         = "Run IAM Access Analyzer evidence export daily"
  schedule_expression = "cron(0 2 * * ? *)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_export.name
  target_id = "lambda-iam-access-analyzer-export"
  arn       = aws_lambda_function.evidence_export.arn
}

resource "aws_lambda_permission" "allow_eventbridge_invoke" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.evidence_export.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_export.arn
}

