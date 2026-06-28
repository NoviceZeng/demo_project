output "db_instance_id" {
  description = "RDS DB instance identifier."
  value       = aws_db_instance.this.id
}

output "db_instance_arn" {
  description = "RDS DB instance ARN."
  value       = aws_db_instance.this.arn
}

output "endpoint" {
  description = "RDS endpoint address."
  value       = aws_db_instance.this.address
}

output "port" {
  description = "RDS endpoint port."
  value       = aws_db_instance.this.port
}

output "security_group_id" {
  description = "Security group ID attached to RDS instance."
  value       = aws_security_group.this.id
}
