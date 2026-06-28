output "replication_group_id" {
  description = "Redis replication group ID."
  value       = aws_elasticache_replication_group.this.id
}

output "primary_endpoint_address" {
  description = "Primary endpoint address."
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "reader_endpoint_address" {
  description = "Reader endpoint address."
  value       = aws_elasticache_replication_group.this.reader_endpoint_address
}

output "security_group_id" {
  description = "Security group ID attached to Redis replication group."
  value       = aws_security_group.this.id
}
