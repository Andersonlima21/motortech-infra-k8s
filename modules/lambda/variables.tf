variable "project" {
  type    = string
  default = "motortech"
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "lambda_zip_path" {
  description = "Caminho para o ZIP da Lambda"
  type        = string
  default     = "lambda.zip"
}

variable "db_host" {
  type = string
}

variable "db_port" {
  type    = string
  default = "3306"
}

variable "db_database" {
  type    = string
  default = "motortech"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "jwt_secret" {
  type      = string
  sensitive = true
}

variable "jwt_ttl" {
  type    = string
  default = "60"
}

variable "app_url" {
  type    = string
  default = ""
}

variable "api_gateway_execution_arn" {
  type = string
}
