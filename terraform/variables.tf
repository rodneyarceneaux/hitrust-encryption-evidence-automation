variable "region" {
  type    = string
  default = "us-east-1"
}

variable "lambda_function_name" {
  type    = string
  default = "hitrust-encryption-audit"
}

variable "evidence_bucket_name" {
  type    = string
  default = "hitrust-evidence-yourinitials"
}
