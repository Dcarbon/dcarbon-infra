output "queue-arn" {
  value = aws_sqs_queue.queue.arn
}

output "queue-url" {
  value = aws_sqs_queue.queue.url
}