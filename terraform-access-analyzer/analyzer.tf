resource "aws_accessanalyzer_analyzer" "org_analyzer" {
  analyzer_name = "access-analyzer-org"
  type          = "ACCOUNT"
}
