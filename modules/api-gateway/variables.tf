variable "project" {
  type    = string
  default = "motortech"
}

variable "environment" {
  type = string
}

variable "lambda_invoke_arn" {
  description = "ARN de invocação da Lambda de autenticação"
  type        = string
}

variable "alb_listener_arn" {
  description = "ARN do listener do ALB"
  type        = string
  default     = ""
}

variable "log_group_arn" {
  description = "ARN do CloudWatch Log Group"
  type        = string
  default     = ""
}
