# Lambda function
resource "aws_lambda_function" "webapp_function" {
  function_name = "${var.app_name}-function"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri = format(
    "%s@%s",
    aws_ecr_repository.app.repository_url,
    data.aws_ecr_image.app.image_digest,
  )
  memory_size = 256
  timeout     = 10

  # ensure the image has been pushed first
  depends_on = [terraform_data.build_push]

}


# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.app_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

