resource "aws_sqs_queue" "main_standard_dlq" {
  name = "${var.queue_name}-dlq"
#   fifo_queue = true
#   content_based_deduplication = true
}

resource "aws_sqs_queue" "main_standard_queue" {
  name = "${var.queue_name}"
#   fifo_queue = true
#   content_based_deduplication = true
  delay_seconds = 0
  visibility_timeout_seconds = 30
  message_retention_seconds   = 1209600 # 14 days
  max_message_size            = 262144  # 256 KB
  receive_wait_time_seconds   = 10

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.main_standard_dlq.arn
    maxReceiveCount = 5 # after 5 failed receives, send to DLQ
  })
  
  depends_on = [ aws_sqs_queue.main_standard_dlq ]
}


