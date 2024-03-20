# Define AWS CodePipeline resource
resource "aws_codepipeline" "pipeline" {
  name          = "my-pipeline"
  role_arn      = aws_iam_role.pipeline.arn
  pipeline_type = "V2"

  # Configure artifact store
  artifact_store {
    location = aws_s3_bucket.artifact_store.bucket
    type     = "S3"
  }

  # Define source stage
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.github_connection
        FullRepositoryId = var.github_repository
        BranchName       = var.github_branch
      }
    }
  }

  # Define build stage
  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.build.name
      }
    }
  }
}

# Define IAM role for CodePipeline
resource "aws_iam_role" "pipeline" {
  name = "pipeline"

  # Define assume role policy
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Action" : "sts:AssumeRole",
      "Principal" : {
        "Service" : "codepipeline.amazonaws.com"
      },
      "Effect" : "Allow",
      "Sid" : ""
    }]
  })
}

# Define IAM policy for CodePipeline
resource "aws_iam_policy" "pipeline_policy" {
  name = "pipeline_policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "codepipeline:StartPipelineExecution",
          "codepipeline:StopPipelineExecution",
          "codepipeline:GetPipeline",
          "codepipeline:GetPipelineExecution",
          "codepipeline:GetPipelineState",
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds",
          "codebuild:BatchGetProjects"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "codestar-connections:UseConnection"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        "Resource" : "arn:aws:s3:::${aws_s3_bucket.artifact_store.bucket}/*"
      }
    ]
  })
}

# Attach IAM policy to role for CodePipeline
resource "aws_iam_role_policy_attachment" "pipeline_policy_attachment" {
  policy_arn = aws_iam_policy.pipeline_policy.arn
  role       = aws_iam_role.pipeline.name
}

# Define S3 bucket for artifact store
resource "aws_s3_bucket" "artifact_store" {
  bucket = var.s3_artifact_bucket_name
}
