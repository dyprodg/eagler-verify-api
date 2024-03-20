provider "aws" {
  region = var.region
}


terraform {
  backend "s3" {
    bucket         = "eagler-verify-api-terraform-state"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "eagler-verify-api-terraform-lock"
    encrypt        = true
  }
}