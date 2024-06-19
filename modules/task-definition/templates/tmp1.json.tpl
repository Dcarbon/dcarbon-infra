[
  {
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": null,
      "options": {
        "awslogs-group": "/ecs/${TASK_FAMILY}-service",
        "awslogs-region": "${REGION}",
        "awslogs-create-group": "true",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "portMappings": [
      {
        "hostPort": ${PORT},
        "protocol": "tcp",
        "containerPort": ${PORT}
      }
    ],
    "cpu": 0,
    "environment": ${ENVIRONMENT},
    "image": "${IMAGE}",
    "name": "${CONTAINER_NAME}"
  }
]