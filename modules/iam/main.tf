resource "aws_iam_role" "web_server_role" {
  name = "web-server-s3-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "web-server-s3-policy"
  description = "Allow Web Server to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:PutObjectAcl",
          "s3:GetObjectAcl",
          "s3:DeleteObjectVersion",
          "s3:GetObjectVersion",
          "s3:ListBucketMultipartUploads",
          "s3:AbortMultipartUpload"
        ]

        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}",
          "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      }
    ]
  })
}


resource "aws_iam_policy" "sqs_access_policy" {
  name        = "web-server-sqs-policy"
  description = "Allow Web Server to access SQS queue"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl"
        ]
        Resource = [
          var.main_standard_queue_arn,
          var.main_standard_dlq_arn
        ]
      }
    ]
  })
}


# Attach s3 access policy to the IAM role
resource "aws_iam_role_policy_attachment" "s3_access_policy_attach" {
  role       = aws_iam_role.web_server_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}


# Attach sqs access policy to the IAM role
resource "aws_iam_role_policy_attachment" "sqs_access_policy_attach" {
  role = aws_iam_role.web_server_role.name
  policy_arn = aws_iam_policy.sqs_access_policy.arn
}

# Create instance profile with attach role
resource "aws_iam_instance_profile" "web_server_profile" {
  name = "web-server-instance-profile"
  role = aws_iam_role.web_server_role.name
}