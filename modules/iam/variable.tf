variable "s3_bucket_name" {
  type        = string
  description = "AWS S3 bucket name"
}


variable "main_standard_queue_arn" {
  type        = string
  description = "ARN of the main standard queue"
}

variable "main_standard_dlq_arn" {
  type        = string
  description = "ARN of the main dead letter standard queue"
}