import boto3
import csv
import io
from datetime import datetime

s3_client = boto3.client('s3')

# CHANGE THIS to your evidence bucket
EVIDENCE_BUCKET = "your-hitrust-evidence-bucket"

def lambda_handler(event, context):
    timestamp = datetime.utcnow().strftime("%Y-%m-%d")
    filename = f"encryption_evidence_{timestamp}.csv"

    # Collect results
    results = []
    results.extend(check_ebs())
    results.extend(check_s3())
    results.extend(check_rds())

    # Write CSV to memory
    csv_buffer = io.StringIO()
    writer = csv.DictWriter(csv_buffer, fieldnames=["resource", "type", "encrypted"])
    writer.writeheader()
    writer.writerows(results)

    # Upload to S3
    s3_client.put_object(
        Bucket=EVIDENCE_BUCKET,
        Key=f"evidence/encryption/{filename}",
        Body=csv_buffer.getvalue()
    )

    return {"status": "success", "file": filename}

def check_ebs():
    ec2 = boto3.client('ec2')
    volumes = ec2.describe_volumes()['Volumes']
    return [
        {"resource": v["VolumeId"], "type": "EBS", "encrypted": v["Encrypted"]}
        for v in volumes
    ]

def check_s3():
    s3 = boto3.client('s3')
    buckets = s3.list_buckets()['Buckets']
    results = []
    for b in buckets:
        name = b["Name"]
        try:
            s3.get_bucket_encryption(Bucket=name)
            encrypted = True
        except:
            encrypted = False
        results.append({"resource": name, "type": "S3 Bucket", "encrypted": encrypted})
    return results

def check_rds():
    rds = boto3.client('rds')
    instances = rds.describe_db_instances()['DBInstances']
    return [
        {"resource": db["DBInstanceIdentifier"], "type": "RDS", "encrypted": db.get("StorageEncrypted", False)}
        for db in instances
    ]


