output "function_name" {
  value = aws_lambda_function.auth.function_name
}

output "function_arn" {
  value = aws_lambda_function.auth.arn
}

output "invoke_arn" {
  value = aws_lambda_function.auth.invoke_arn
}

output "security_group_id" {
  value = aws_security_group.lambda.id
}
