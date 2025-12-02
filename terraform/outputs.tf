output "lambda_function_name" {
  value = aws_lambda_function.encryption_audit.function_name
}

output "evidence_bucket" {
  value = aws_s3_bucket.evidence.bucket
}

output "schedule_rule" {
  value = aws_cloudwatch_event_rule.daily_schedule.name
}
