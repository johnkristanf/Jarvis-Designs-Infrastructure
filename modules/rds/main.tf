resource "aws_db_subnet_group" "rds" {
  name       = "main-rds-subnet-group"
  subnet_ids = [var.private_a_subnet_id, var.private_b_subnet_id]
  description = "Main RDS Subnet Group"
}


# Custom DB Config
resource "aws_db_parameter_group" "production"{
  family = "postgres16"
  name   = "jarvis-postgres16-production"
  description = "Production-optimized parameters for PostgreSQL 16"

  # =========================
  # TIER 1: CRITICAL PERFORMANCE (Must Have)
  # =========================
  
  # Memory Management - Core performance
  parameter {
    name         = "shared_buffers"
    value        = "32768"        # Scale up for production (25-40% of RAM)
    apply_method = "pending-reboot"
  }
  
  parameter {
    name         = "effective_cache_size"
    value        = "131072"       # 75% of total available memory
    apply_method = "immediate"
  }
  
  parameter {
    name         = "work_mem"
    value        = "4096"          # Per-connection memory for sorts/joins
    apply_method = "immediate"
  }
  
  parameter {
    name         = "maintenance_work_mem"
    value        = "65536"        # 64MB in KB
    apply_method = "immediate"
  }

  # SSD Optimization - Critical
  parameter {
    name         = "random_page_cost"
    value        = "1.1"          # SSD optimization
    apply_method = "immediate"
  }
  
  parameter {
    name         = "effective_io_concurrency"
    value        = "200"          # SSD can handle concurrent I/O
    apply_method = "immediate"
  }

  # Connection Management
  parameter {
    name         = "max_connections"
    value        = "100"          # Higher for production load
    apply_method = "pending-reboot"
  }
}



resource "aws_db_instance" "main" {
  identifier             = "main-rds-db"
  engine                 = "postgres"
  engine_version         = "16.9"
  instance_class         = "db.t4g.micro"
  storage_type           = "gp2"

  allocated_storage      = 20
  max_allocated_storage  = 100

  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password

  parameter_group_name   = aws_db_parameter_group.production.name
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [var.rds_sg_id]

  multi_az = false
  availability_zone =   "ap-southeast-1a"
  skip_final_snapshot    = true
  deletion_protection    = false
  publicly_accessible    = false
}