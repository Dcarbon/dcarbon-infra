output "cluster-name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "service-name" {
  value = aws_ecs_service.ecs_service.name
}