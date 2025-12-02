import boto3
import json
import csv
import os
import datetime
from io import StringIO

# Clients
access_analyzer = boto3.client("accessanalyzer")
s3 = boto3.client("s3")

# Environment variables (set in Terraform)
BUCKET = os.environ["EVIDENCE_BUCKET"]
ANALYZER_NAME = os.environ["ANALYZER_NAME"]
ACCOUNT_ID = os.environ["ACCOUNT_ID"]

def normalize_finding(f):
    """Extract key fields auditors care about."""
    return {
        "id": f.get("id"),
        "resourceType": f.get("resourceType"),
        "resource": f.get("resource"),
        "isPublic": f.get("isPublic"),
        "createdAt": f.get("createdAt").isoformat() if f.get("createdAt") else None,
        "status": f.get("status"),
        "findingType": f.get("findingType"),
        "principal": f.get("principal"),
        "action": f.get("action"),
        "condition": f.get("condition"),
    }

def write_s3_json(obj, key):
    s3.put_object(
        Bucket=BUCKET,
        Key=key,
        Body=json.dumps(obj, default=str),
        ContentType="application/json"
    )

def write_s3_csv(rows, key):
    fields = sorted({k for r in rows for k in r.keys()})
    buf = StringIO()
    writer = csv.DictWriter(buf, fieldnames=fields)
    writer.writeheader()
    for r in rows:
        writer.writerow(r)
    s3.put_object(
        Bucket=BUCKET,
        Key=key,
        Body=buf.getvalue(),
        ContentType="text/csv"
    )

def handler(event, context):
    today = datetime.datetime.utcnow()
    prefix = today.strftime("evidence/%Y/%m/%d")
    meta_key = f"{prefix}/metadata.json"
    json_key = f"{prefix}/access-analyzer-findings.json"
    csv_key  = f"{prefix}/access-analyzer-findings.csv"

    # Collect findings
    findings = []
    params = {"analyzerName": ANALYZER_NAME, "maxResults": 1000}
    while True:
        resp = access_analyzer.list_findings(**params)
        findings.extend(resp.get("findings", []))
        token = resp.get("nextToken")
        if not token:
            break
        params["nextToken"] = token

    normalized = [normalize_finding(f) for f in findings]

    # Metadata summary
    summary = {
        "accountId": ACCOUNT_ID,
        "analyzerName": ANALYZER_NAME,
        "region": os.environ.get("AWS_REGION"),
        "timestamp": today.isoformat() + "Z",
        "totalFindings": len(normalized),
        "publicFindings": sum(1 for x in normalized if x.get("isPublic")),
    }

    # Write evidence
    write_s3_json(summary, meta_key)
    write_s3_json(normalized, json_key)
    write_s3_csv(normalized, csv_key)

    return {"status": "ok", "summary": summary}
