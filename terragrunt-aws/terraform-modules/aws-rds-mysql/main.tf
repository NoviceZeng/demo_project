resource "aws_db_subnet_group" "this" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.identifier}-subnet-group"
  })
}

resource "aws_security_group" "this" {
  name        = "${var.identifier}-sg"
  description = "Security group for RDS MySQL ${var.identifier}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.identifier}-sg"
  })
}

resource "aws_db_instance" "this" {
  identifier                 = var.identifier
  engine                     = "mysql"
  engine_version             = var.engine_version
  instance_class             = var.instance_class
  db_name                    = var.db_name
  username                   = var.username
  password                   = var.password
  allocated_storage          = var.allocated_storage
  max_allocated_storage      = var.max_allocated_storage > 0 ? var.max_allocated_storage : null
  storage_type               = var.storage_type
  storage_encrypted          = var.storage_encrypted
  port                       = var.port
  multi_az                   = var.multi_az
  publicly_accessible        = false
  backup_retention_period    = var.backup_retention_period
  deletion_protection        = var.deletion_protection
  skip_final_snapshot        = var.skip_final_snapshot
  final_snapshot_identifier  = var.final_snapshot_identifier
  db_subnet_group_name       = aws_db_subnet_group.this.name
  vpc_security_group_ids     = [aws_security_group.this.id]
  apply_immediately          = true
  auto_minor_version_upgrade = true

  tags = merge(var.tags, {
    Name = var.identifier
  })
}
