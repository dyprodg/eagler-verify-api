variable "region" {
  description = "The AWS region"
  default     = "us-west-1"
}

variable "api_name" {
  description = "The name of the API Gateway"
  default     = "MyAPI"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  default     = "lambda_function_name"
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
  default     = "secret-id"
}

variable "secret_arn" {
  description = "The ARN of the secret in AWS Secrets Manager"
  default     = "secret-arn"
}

variable "github_connection" {
  description = "The connection to GitHub"
  default     = "github-connection"
}

variable "github_repository" {
  description = "The GitHub repository"
  default     = "repo-name"
}

variable "github_branch" {
  description = "The GitHub branch"
  default     = "main"
}

variable "build_project_name" {
  description = "The name of the CodeBuild project"
  default     = "my-build-project"
}


variable "s3_artifact_bucket_name" {
  description = "The name of the S3 bucket for the CodePipeline artifact"
  default     = "my-artifact-bucket"
}

variable "codebuild_compute_type" {
  description = "The compute type of the CodeBuild project"
  default     = "BUILD_GENERAL1_SMALL"

}

variable "codebuild_image" {
  description = "The image of the CodeBuild project"
  default     = "aws/codebuild/standard:7.0"

}

variable "codebuild_env_type" {
  description = "The environment type of the CodeBuild project"
  default     = "LINUX_CONTAINER"
}

variable "build_log_group_name" {
  description = "The name of the CloudWatch Logs group"
  default     = "my-build-log-group"
}

variable "build_log_stream_name" {
  description = "The name of the CloudWatch Logs stream"
  default     = "my-build-log-stream"
}
