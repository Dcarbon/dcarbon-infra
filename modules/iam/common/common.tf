data "aws_iam_policy_document" "medialive-assume-role" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["medialive.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "media-live-access" {
  count              = contains(var.BUILD_RESOURCE, "MEDIA_LIVE") ? 1 : 0
  name               = "${var.PROJECT_NAME}-${var.ENV}-media-live-access"
  assume_role_policy = data.aws_iam_policy_document.medialive-assume-role.json
  inline_policy {
    name = "AmazonMedialiveRolePolicy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "logs",
          "Effect" : "Allow",
          "Action" : [
            "logs:PutLogEvents",
            "logs:DescribeLogStreams",
            "logs:DescribeLogGroups",
            "logs:CreateLogStream",
            "logs:CreateLogGroup"
          ],
          "Resource" : "arn:aws:logs:*:*:*"
        },
        {
          "Sid" : "mediapackage",
          "Effect" : "Allow",
          "Action" : "mediapackage:DescribeChannel",
          "Resource" : "*"
        },
        {
          "Sid" : "ec2",
          "Effect" : "Allow",
          "Action" : [
            "ec2:describeSubnets",
            "ec2:describeSecurityGroups",
            "ec2:describeNetworkInterfaces",
            "ec2:describeAddresses",
            "ec2:deleteNetworkInterfacePermission",
            "ec2:deleteNetworkInterface",
            "ec2:createNetworkInterfacePermission",
            "ec2:createNetworkInterface",
            "ec2:associateAddress"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "s3",
          "Effect" : "Allow",
          "Action" : [
            "s3:PutObject",
            "s3:ListBucket",
            "s3:GetObject",
            "s3:DeleteObject"
          ],
          "Resource" : "*"
        }
      ]
    })
  }
  tags = merge({
    service = var.PROJECT_SERVICE_TYPE
  }, var.TAGS)
}

resource "aws_iam_role_policy_attachment" "media-live-access-role-attach" {
  count      = contains(var.BUILD_RESOURCE, "MEDIA_LIVE") ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  role       = aws_iam_role.media-live-access[count.index].name
}
//ECS
data "aws_iam_policy_document" "ecs-task-assume-role" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "ecs-task-execute" {
  count              = contains(var.BUILD_RESOURCE, "ECS") ? 1 : 0
  name               = "${var.PROJECT_NAME}-${var.ENV}-ecs-task-execute"
  description        = "Allows ECS tasks to call AWS services on your behalf."
  assume_role_policy = data.aws_iam_policy_document.ecs-task-assume-role.json
  inline_policy {
    name = "AmazonCloudWatchCreateLogGroupRolePolicy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogGroup",
            "logs:DescribeLogStreams"
          ],
          "Resource" : [
            "arn:aws:logs:*:*:*"
          ]
        },
        {
          "Effect" : "Allow",
          Action : [
            "ses:SendEmail"
          ]
          Resource : ["arn:aws:ses:${var.AWS_REGION}:${var.AWS_ACCOUNT_ID}:identity/*"]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "ssm:GetParameters",
            "ssm:GetParameter",
          ],
          "Resource" : [
            "arn:aws:ssm:${var.AWS_REGION}:${var.AWS_ACCOUNT_ID}:parameter/${var.PROJECT_NAME}/*",
          ]
        }
      ]
    })
  }
}
resource "aws_iam_role_policy_attachment" "ecs-task-execute-role-attach" {
  count      = contains(var.BUILD_RESOURCE, "ECS") ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs-task-execute[count.index].name
}
//APPSYNC
data "aws_iam_policy_document" "appsync-logs-assume-role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["appsync.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "appsync-logs-execute" {
  count              = contains(var.BUILD_RESOURCE, "APPSYNC") ? 1 : 0
  name               = "${var.PROJECT_NAME}-${var.ENV}-appsync-logs-execute"
  assume_role_policy = data.aws_iam_policy_document.appsync-logs-assume-role.json
}

resource "aws_iam_role_policy_attachment" "AWSAppSyncPushToCloudWatchLogs" {
  count      = contains(var.BUILD_RESOURCE, "APPSYNC") ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppSyncPushToCloudWatchLogs"
  role       = aws_iam_role.appsync-logs-execute[count.index].name
}