variable "aws_region" {
  description = "The AWS Region to deploy resources"
  type        = string
  default     = "ap-southeast-1"
}


variable "aws_profile" {
  description = "The AWS Cli Profile"
  type        = string
  default     = "johnkristan.torremocha01"
}


variable "aws_s3_bucket_name" {
  description = "AWS S3 Bucket Name"
  type        = string
  default     = "jarvis-designs"
}


variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}


variable "db_name" {
  description = "Database name for the RDS instance"
  type        = string
}

variable "db_username" {
  description = "Master username for RDS"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master password for RDS"
  type        = string
  sensitive   = true
}
