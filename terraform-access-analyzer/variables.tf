variable "region" {
  default = "us-east-1"
}

variable "export_bucket_name" {
  description = "Bucket used to store IAM Access Analyzer findings"
  default     = "access-analyzer-evidence"
}
