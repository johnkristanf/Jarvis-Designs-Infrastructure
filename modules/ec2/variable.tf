variable "instance_profile_name" {
  description = "AWS EC2 Instance Profile Name"
}

variable "subnet_id" {
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