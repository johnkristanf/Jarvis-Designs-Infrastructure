output "main_standard_queue_arn" {
  value = aws_sqs_queue.main_standard_queue.arn
}

output "main_standard_dead_letter_queue_arn" {
  value = aws_sqs_queue.main_standard_dlq.arn
}