variable "instance_profile_name" {
  description = "AWS EC2 Instance Profile Name"
}

variable "public_subnet_id" {
  description = "AWS EC2 Subnet ID"
}

variable "instance_type" {
  type        = string
  description = "AWS EC2 Instance Type"
}

variable "region" {
  type        = string
  description = "AWS EC2 Region"
}

variable "web_server_sg_id" {
  description = "EC2 Security Groups IDs"
}