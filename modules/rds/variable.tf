variable "private_a_subnet_id" {
  description = "The private subnet A id"
}

variable "private_b_subnet_id" {
  description = "The private subnet B id"
}

variable "rds_sg_id" {
  description = "RDS Security Group ID"
}



variable "db_name" {
  description = "Database name for the RDS instance"
  type        = string
}

variable "db_username" {
  description = "Master username for RDS"
  type        = string
}

variable "db_password" {
  description = "Master password for RDS"
  type        = string
}
