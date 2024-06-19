{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": ${LIST_PUBLIC_ACTION},
      "Resource": ${LIST_PUBLIC_DIR}
    },
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