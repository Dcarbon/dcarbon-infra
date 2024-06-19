{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Principal": {
        "AWS": ${LIST_AWS_ARN}
      },
      "Action":${LIST_PRIVATE_ACTION},
      "Resource": ${LIST_PRIVATE_DIR}
    }
  ]
}