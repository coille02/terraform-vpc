output "qa_aurora_param_mysql57_id" {
  value = aws_db_parameter_group.qa-aurora-param-mysql57[*]
}

output "qa_aurora_cluster_param_mysql57_id" {
  value = aws_rds_cluster_parameter_group.qa-aurora-param-cluster-mysql57[*]
}

output "aurora_param_mysql57_id" {
  value = aws_db_parameter_group.aurora-param-mysql57[*]
}

output "aurora_cluster_param_mysql57_id" {
  value = aws_rds_cluster_parameter_group.aurora-param-cluster-mysql57[*]
}

