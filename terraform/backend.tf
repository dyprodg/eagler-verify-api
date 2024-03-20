provider "aws" {
  region = var.region
}


terraform {
  backend "s3" {
    bucket         = "state-bucket-name"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "state-table"
    encrypt        = true
  }
}