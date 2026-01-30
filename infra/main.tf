terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.30.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}


#=================================================
# variables
#=================================================
variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "aws_profile" {
  description = "AWS SSO profile name"
  type        = string
}

variable "container_tool" {
  description = "container tool"
  type        = string
}

#=================================================
# variables
#=================================================

output "api_endpoint" {
  description = "API Gateway endpoint URL"
  value       = aws_apigatewayv2_stage.default.invoke_url
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.app.repository_url
}

output "function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.webapp_function.function_name
}
