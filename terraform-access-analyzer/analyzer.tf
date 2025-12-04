resource "aws_accessanalyzer_analyzer" "account" {
  analyzer_name = "access-analyzer-org"
  type          = "ACCOUNT"
}

