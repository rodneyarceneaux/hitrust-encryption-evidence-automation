# hitrust-encryption-evidence-automation

HITRUST Encryption Evidence Automation

Automated evidence collection for HITRUST R2 encryption controls using Python + AWS APIs.

📌 Overview

HITRUST requires organizations to provide recurring evidence that all sensitive data is encrypted at rest.
This is one of the highest-friction audit tasks, especially during R2 assessments.

This script automatically:

Enumerates EBS volumes, S3 buckets, and RDS databases

Validates encryption at rest status

Generates a timestamped CSV evidence file

Can be run manually, scheduled via cron, or triggered via Lambda

🧩 Why This Matters

This automation eliminates:

Manual evidence collection

Repeated screenshots

Last-minute audit scrambling

Risk of missing non-compliant resources

It supports a continuous compliance approach aligned with modern GRC engineering.

🛡 HITRUST Control Mappings
HITRUST Domain	Control ID	Description
Information Protection	0.B	Encryption of data at rest
Access Control	01.e	Key management & encryption enforcement
Operations Security	10.j	Logging & monitoring of non-compliant resources
Asset Management	08.e	Inventory & classification of encrypted assets
🚀 How It Works

The script:

Uses boto3 to query AWS resources

Checks encryption status

Aggregates results across EBS / S3 / RDS

Writes a CSV evidence file with a UTC timestamp
