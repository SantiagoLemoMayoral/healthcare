resource "aws_sqs_queue" "dlq" {
  name = "lab-dlq"
}

resource "aws_sqs_queue" "main" {
  name = "lab-queue"

  visibility_timeout_seconds = 60

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 5
  })
}

resource "aws_lambda_event_source_mapping" "worker" {
  event_source_arn = aws_sqs_queue.main.arn
  function_name    = aws_lambda_function.worker.arn

  batch_size = 10
}

