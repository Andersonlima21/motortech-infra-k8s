# IAM Role for Lambda
resource "aws_iam_role" "lambda" {
  name = "${var.project}-auth-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda.name
}

resource "aws_iam_role_policy_attachment" "lambda_vpc" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.lambda.name
}

# Security Group for Lambda
resource "aws_security_group" "lambda" {
  name_prefix = "${var.project}-lambda-"
  vpc_id      = var.vpc_id
  description = "Security group for Lambda auth function"

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidrs
    description = "Allow MySQL to RDS"
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS outbound"
  }

  tags = {
    Name = "${var.project}-lambda-sg"
  }
}

# Lambda Function
resource "aws_lambda_function" "auth" {
  function_name = "${var.project}-auth-lambda-${var.environment}"
  role          = aws_iam_role.lambda.arn
  handler       = "src/index.handler"
  runtime       = "nodejs20.x"
  timeout       = 10
  memory_size   = 256

  filename         = var.lambda_zip_path
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.lambda.id]
  }

  environment {
    variables = {
      DB_HOST     = var.db_host
      DB_PORT     = var.db_port
      DB_DATABASE = var.db_database
      DB_USERNAME = var.db_username
      DB_PASSWORD = var.db_password
      JWT_SECRET  = var.jwt_secret
      JWT_TTL     = var.jwt_ttl
      APP_URL     = var.app_url
    }
  }

  tags = {
    Name        = "${var.project}-auth-lambda"
    Environment = var.environment
  }
}

# Permission for API Gateway to invoke Lambda
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auth.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_execution_arn}/*/*"
}
