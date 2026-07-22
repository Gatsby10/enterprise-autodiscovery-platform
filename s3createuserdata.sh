#!/usr/bin/env bash
set -euo pipefail

# ── Config ────────────────────────────────────────────────────
BUCKET_NAME="terraform-state-$(aws sts get-caller-identity --query Account --output text)"
REGION="eu-west-3"
DYNAMODB_TABLE="pet-adoption-state-bucket-one-dynamodb-lock"

echo "Creating S3 backend: pet-adoption-state-bucket-one"

# ── 1. Create S3 bucket (Object Lock must be set at creation) ─
aws s3api create-bucket --bucket "pet-adoption-state-bucket-one" --region "eu-west-3" --object-lock-enabled-for-bucket --create-bucket-configuration LocationConstraint="eu-west-3"
echo "✔ Bucket created"

# ── 2. Enable versioning ──────────────────────────────────────
aws s3api put-bucket-versioning --bucket "pet-adoption-state-bucket-one" --versioning-configuration Status=Enabled
echo "✔ Versioning enabled"


# ── 5. Create DynamoDB lock table ─────────────────────────────
aws dynamodb create-table --table-name "pet-adoption-state-bucket-one-dynamodb-lock" --region "eu-west-3" --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST --output json > /dev/null
echo "✔ DynamoDB lock table created: pet-adoption-state-bucket-one-dynamodb-lock"

echo ""
echo "Done. Run: terraform init"

echo "Creating Vault and Jenkins Server"
cd jenkins-vault
terraform init 
terraform validate
terraform apply -auto-approve