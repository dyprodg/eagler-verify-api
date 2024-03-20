# Define CodeBuild project
resource "aws_codebuild_project" "build" {
  name          = var.build_project_name  
  description   = "My CodeBuild project"  
  service_role  = aws_iam_role.codebuild.arn  
  build_timeout = 5  

  # Define source settings for the project.
  source {
    type      = "CODEPIPELINE"  
    buildspec = "buildspec.yml"  
  }

  # Define artifact settings for the project.
  artifacts {
    type = "CODEPIPELINE" 
  }

  # Define environment settings for the project.
  environment {
    compute_type                = var.codebuild_compute_type  
    image                       = var.codebuild_image  
    type                        = var.codebuild_env_type  
    image_pull_credentials_type = "CODEBUILD"  
  }

  # Define logs configuration for the project.
  logs_config {
    cloudwatch_logs {
      group_name  = var.build_log_group_name  
      stream_name = var.build_log_stream_name  
    }
  }
}

# Define IAM role for CodeBuild
resource "aws_iam_role" "codebuild" {
  name = "codebuild"  

  # Define assume role policy allowing CodeBuild to assume this role.
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Action" : "sts:AssumeRole",
      "Principal" : {
        "Service" : "codebuild.amazonaws.com"
      },
      "Effect" : "Allow",
      "Sid" : ""
    }]
  })
}

# Define IAM policy for CodeBuild
resource "aws_iam_role_policy" "codebuild" {
  role = aws_iam_role.codebuild.id  

  # Define permissions for CodeBuild.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "codecommit:GitPull",
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Resource" : "*"  
      },
      {
        "Effect" : "Allow",
        "Action" : "lambda:UpdateFunctionCode",
        "Resource" : "${aws_iam_role.iam_for_lambda.arn}" 
      },
    ]
  })
}
