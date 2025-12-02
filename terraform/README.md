Terraform Deployment

This project includes full Terraform IaC to deploy the HITRUST encryption evidence automation pipeline:

terraform/
  lambda.tf
  iam.tf
  s3.tf
  eventbridge.tf
  variables.tf
  main.tf
  outputs.tf

Deploying:
cd terraform
terraform init
terraform apply


Terraform provisions:

AWS Lambda (Python 3.12)

IAM role with least-privilege permissions

Evidence S3 bucket (encrypted + versioned)

EventBridge daily schedule

CloudWatch logs

This enables continuous, automated evidence collection for HITRUST R2 encryption controls.
