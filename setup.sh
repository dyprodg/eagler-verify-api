#!/bin/bash

s3_bucket_name="my-terraform-state-bucket-dyprodg-12334"
dynamodb_table_name="terraform-api-state"
aws_region="eu-central-1"

# Create the S3 bucket
if ! aws s3api create-bucket --bucket "$s3_bucket_name" --region "$aws_region" --create-bucket-configuration LocationConstraint="$aws_region"; then
    echo "Failed to create S3 bucket. Exiting."
    exit 1
fi

# Check if the DynamoDB table already exists
if ! aws dynamodb describe-table --table-name "$dynamodb_table_name" --region "$aws_region" > /dev/null 2>&1; then
    # Create the DynamoDB table
    if ! aws dynamodb create-table \
        --table-name "$dynamodb_table_name" \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
        --region "$aws_region"; then
        echo "Failed to create DynamoDB table. Exiting."
        exit 1
    fi
fi

echo "S3 bucket and DynamoDB table created successfully."
echo "$s3_bucket_name"
echo "$dynamodb_table_name"

# Update the backend.tf file with the actual bucket and DynamoDB table names and region
if ! sed -i '' "s/terraformstatebucket/$s3_bucket_name/g" terraform/backend.tf ||
    ! sed -i '' "s/terraform-lock/$dynamodb_table_name/g" terraform/backend.tf ||
    ! sed -i '' "s/region = \"us-west-2\"/region = \"$aws_region\"/g" terraform/backend.tf; then
    echo "Failed to update backend.tf file. Exiting."
    exit 1
fi

# Update the variables.tf file with the new region variable name
if ! sed -i '' "s/eu-central-1/$new_aws_region/g" terraform/variables.tf; then
    echo "Failed to update variables.tf file. Exiting."
    exit 1
fi

echo "'backend.tf' file updated with the correct values. You can now run 'terraform init'."

cd terraform
terraform init
cd ..
