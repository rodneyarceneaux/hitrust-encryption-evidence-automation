resource "aws_cloudwatch_event_rule" "daily_schedule" {
  name                = "hitrust-encryption-audit-schedule"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "schedule_target" {
  rule      = aws_cloudwatch_event_rule.daily_schedule.name
  target_id = "lambda"
  arn       = aws_lambda_function.encryption_audit.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.encryption_audit.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_schedule.arn
}
