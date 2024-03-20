#!/bin/bash

# Package the Lambda function
zip -r terraform/dummy.zip lambda/*

# Go to the terraform directory
cd terraform

# Validate the Terraform code
terraform validate

# Apply the Terraform configuration
terraform apply -auto-approve


