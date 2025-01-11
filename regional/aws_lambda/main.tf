
# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow",
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Custom IAM Policy for Lambda VPC access
resource "aws_iam_policy" "lambda_vpc_access_policy" {
  name        = "lambda-vpc-access-policy"
  description = "Policy for Lambda to access VPC"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        Effect   = "Allow",
        Resource = "*",
      },
        {
          Action = [
              "ec2:CreateNetworkInterface",
              "ec2:DeleteNetworkInterface",
              "ec2:DescribeNetworkInterfaces",
          ],
        Effect = "Allow",
        Resource = "*",
      },
    ]
  })
}

# Attach the Custom Policy to the Role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_vpc_access_policy.arn
}


# Create the Lambda function
resource "aws_lambda_function" "my_lambda" {
  function_name = "karyanirkshan-tf-lambda"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "nodejs20.x"
  filename      = "node_modules.zip"
  timeout       = 30
  memory_size   = 512
  vpc_config {
    subnet_ids         = ["subnet-0425390e66208ccb4"]
    security_group_ids = ["sg-01847788cdd91688f"]
  }
}

# # Create Lambda Function URL
# resource "aws_lambda_function_url" "my_lambda_url" {
#   function_name      = aws_lambda_function.my_lambda.function_name
#   authorization_type = "NONE"
#   cors {
#     allow_credentials = false
#     allow_origins     = ["*"]
#     allow_headers     = ["*"]
#     allow_methods     = ["*"]
#   }
# }


# Output the Lambda function ARN
output "lambda_arn" {
  value = aws_lambda_function.my_lambda.arn
}

# Output the Lambda function URL
# output "lambda_url" {
#   value = aws_lambda_function_url.my_lambda_url.function_url
# }