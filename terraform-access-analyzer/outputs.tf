output "analyzer_name" {
  value = aws_accessanalyzer_analyzer.org_analyzer.analyzer_name
}

output "export_bucket" {
  value = aws_s3_bucket.export_bucket.bucket
}

output "lambda_function_name" {
  value = aws_lambda_function.evidence_export.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.evidence_export.arn
}

output "eventbridge_rule_name" {
  value = aws_cloudwatch_event_rule.daily_export.name
}
