# Define an API Gateway REST API resource.
resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_name  
  description = "My API Gateway"
}

# Define a resource within the API Gateway REST API.
resource "aws_api_gateway_resource" "api_resource_verify" {
  rest_api_id = aws_api_gateway_rest_api.api.id 
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id  
  path_part   = "verify"
}

# Define a method for the API resource.
resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id 
  resource_id   = aws_api_gateway_resource.api_resource_verify.id  
  http_method   = "GET"
  authorization = "NONE"
}

# Define an integration for the API method, connecting it to a Lambda function.
resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id  
  resource_id             = aws_api_gateway_resource.api_resource_verify.id  
  http_method             = aws_api_gateway_method.api_method.http_method  
  integration_http_method = "POST" 
  type                    = "AWS_PROXY" 
  uri                     = aws_lambda_function.lambda.invoke_arn  
}

# Define a deployment for the API Gateway REST API.
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on  = [aws_lambda_function.lambda]  
  rest_api_id = aws_api_gateway_rest_api.api.id  
  stage_name  = "prod" 
}

# Define permissions to allow API Gateway to invoke the Lambda function.
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke" 
  action        = "lambda:InvokeFunction" 
  function_name = aws_lambda_function.lambda.function_name 
  principal     = "apigateway.amazonaws.com" 

  # Define the source ARN for the permission.
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

# Define an integration between API Gateway and the Lambda function.
resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.api.id 
  resource_id = aws_api_gateway_resource.api_resource_verify.id  
  http_method = aws_api_gateway_method.api_method.http_method  

  # Specify the integration HTTP method and type.
  integration_http_method = "POST"
  type                    = "AWS_PROXY"

  # Set the URI for the Lambda function integration.
  uri                     = aws_lambda_function.lambda.invoke_arn
}

output "api_staging_url" {
  value = aws_api_gateway_deployment.api_deployment.invoke_url
}
