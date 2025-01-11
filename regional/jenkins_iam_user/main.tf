# Create IAM User for Jenkins
resource "aws_iam_user" "jenkins_user" {
  name = "jenkins-deployer"
}

# Create IAM Policy for Lambda Deployment
resource "aws_iam_policy" "lambda_deployment_policy" {
  name        = "jenkins-lambda-deployment-policy"
  description = "Policy for Jenkins to deploy to AWS Lambda"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "lambda:CreateFunction",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "lambda:PublishVersion",
          "lambda:GetFunction",
          "lambda:GetFunctionConfiguration",
          "lambda:DeleteFunction",
        ],
        Effect   = "Allow",
        Resource = "*", # Adjust this to specific Lambda ARNs for production
      },
      {
        Action = [
          "iam:PassRole"
        ],
        Effect   = "Allow",
          Resource = "*", #Adjust this to specific IAM role ARN for production
      },
    #   {
    #     Action = [
    #         "s3:GetObject",
    #         "s3:PutObject"
    #     ],
    #     Effect = "Allow",
    #     Resource = ["arn:aws:s3:::<your-s3-bucket>/*"], # Provide specific S3 bucket ARN for production
    #   }
    ]
  })
}


# Attach Policy to the User
resource "aws_iam_user_policy_attachment" "jenkins_policy_attachment" {
  user       = aws_iam_user.jenkins_user.name
  policy_arn = aws_iam_policy.lambda_deployment_policy.arn
}


# Create Access Key and Secret Key
resource "aws_iam_access_key" "jenkins_access_key" {
  user = aws_iam_user.jenkins_user.name
}

# Output the Access Key and Secret Key
output "jenkins_access_key" {
  value = aws_iam_access_key.jenkins_access_key.id
}

output "jenkins_secret_key" {
    value     = aws_iam_access_key.jenkins_access_key.secret
    sensitive = true
}