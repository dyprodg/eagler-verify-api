variable "region" {
  description = "The AWS region"
  default     = "eu-central-1"
}

variable "api_name" {
  description = "The name of the API Gateway"
  default     = "eagler-api-verify-mail"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  default     = "eagler-lambda-verify-mail"
}

variable "lambda_handler" {
  description = "The handler of the Lambda function"
  default     = "lambda/index.handler"
}

variable "lambda_runtime" {
  description = "The runtime of the Lambda function"
  default     = "nodejs18.x"
}

variable "lambda_architecture" {
  description = "The architecture of the Lambda function"
  default     = ["x86_64"]
}

variable "lambda_memory_size" {
  description = "The memory size of the Lambda function"
  default     = 128
}

variable "secret_id" {
  description = "The ID of the secret in AWS Secrets Manager"
  default     = "eagler-secrets-A8629Z"
}

variable "secret_arn" {
  description = "The ARN of the secret in AWS Secrets Manager"
  default     = "arn:aws:secretsmanager::283919506801:secret:eagler-secrets-A8629Z"
}

variable "github_connection" {
  description = "The connection to GitHub"
  default     = "arn:aws:codestar-connections:eu-central-1:283919506801:connection/2eb166a7-605d-4e03-bb58-3c2d2af5da4e"
}

variable "github_repository" {
  description = "The GitHub repository"
  default     = "dyprodg/eagler-verify-api"
}

variable "github_branch" {
  description = "The GitHub branch"
  default     = "main"
}

variable "build_project_name" {
  description = "The name of the CodeBuild project"
  default     = "eagler-build-verify-mail"
}


variable "s3_artifact_bucket_name" {
  description = "The name of the S3 bucket for the CodePipeline artifact"
  default     = "eagler-artifact-verify-bucket"
}

variable "codebuild_compute_type" {
  description = "The compute type of the CodeBuild project"
  default     = "BUILD_LAMBDA_2GB"

}

variable "codebuild_image" {
  description = "The image of the CodeBuild project"
  default     = "aws/codebuild/amazonlinux-x86_64-lambda-standard:nodejs18"

}

variable "codebuild_env_type" {
  description = "The environment type of the CodeBuild project"
  default     = "LINUX_LAMBDA_CONTAINER"
}

variable "build_log_group_name" {
  description = "The name of the CloudWatch Logs group"
  default     = "eagler-build-verify-mail"
}

variable "build_log_stream_name" {
  description = "The name of the CloudWatch Logs stream"
  default     = "eagler-build-verify-mail"
}
