output "analyzer_name" {
  value = aws_accessanalyzer_analyzer.org_analyzer.analyzer_name
}

output "export_bucket" {
  value = aws_s3_bucket.export_bucket.bucket
}
