output "api_endpoint" {
  value = aws_apigatewayv2_api.main.api_endpoint
}

output "api_id" {
  value = aws_apigatewayv2_api.main.id
}

output "execution_arn" {
  value = aws_apigatewayv2_api.main.execution_arn
}

output "log_group_arn" {
  value = aws_cloudwatch_log_group.api_gw.arn
}
