# Define an IAM role for the Lambda function, granting it permissions to assume the role.
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  # Define the policy allowing the Lambda service to assume this role.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies to the IAM role granting necessary permissions for the Lambda function.
resource "aws_iam_role_policy" "policy" {
  name = "lambda_policy"
  role = aws_iam_role.iam_for_lambda.id

  # Define policies granting access to AWS services such as Secrets Manager and CloudWatch Logs.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "secretsmanager:GetSecretValue"
        Resource = var.secret_arn  # Allow Lambda to access the specified secret ARN.
      },
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogGroup",   
          "logs:CreateLogStream", 
          "logs:PutLogEvents"     
        ]
        Resource = "arn:aws:logs:*:*:*"  
      }
    ]
  })
}

# Define the Lambda function itself.
resource "aws_lambda_function" "lambda" {
  function_name    = var.lambda_function_name  
  role             = aws_iam_role.iam_for_lambda.arn  
  handler          = var.lambda_handler  
  runtime          = var.lambda_runtime  
  architectures    = var.lambda_architecture  
  memory_size      = var.lambda_memory_size 
  filename         = "dummy.zip"  

  # Define environment variables for the Lambda function.
  environment {
    variables = {
      SECRET_ID = var.secret_id  # Set the environment variable for the secret ID.
    }
  }

  # Ignore changes to the filename attribute to prevent unnecessary updates.
  lifecycle {
    ignore_changes = [filename]
  }
}
