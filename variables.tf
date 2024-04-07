variable "cidr_block" {
  type = string
}

variable "project_name" {
    type = string
}

variable "enable_dns_hostnames" {
  type = bool
  validation{
    condition = var.enable_dns_hostnames == true
    error_message = "Must be enabled"
  }
}

variable "common_tags" {
  type = map
}

variable "vpc_tgas" {
  type = map
}

variable "igw_tags" {
  type = map
}

variable "public_subnet_cidr_block" {
  type = list
  validation {
    condition = length(var.public_subnet_cidr_block) <= 2 
    error_message = "Only 2 subnets are allowed to create"
  }
}
variable "public_subnet_tags" {
  type = list
}

variable "private_subnet_cidr_block" {
  type = list
  validation {
    condition = length(var.private_subnet_cidr_block) <= 2
    error_message =  "Only 2 subnets are allowed to create"
  }
}

variable "private_subnet_tags" {
  type = list
}

variable "database_subnet_cidr_block" {
  type = list
  validation {
    condition = length(var.database_subnet_cidr_block) <= 2
    error_message = "Only 2 subnets are allowed to create"
  }
}

variable "database_subnet_tags" {
  type = list
}

variable "public_route_table_tags" {
  type = map
}

variable "private_route_table_tags" {
  type = map
}

variable "database_route_table_tags" {
  type = map
}

variable "aws_nat_gateway_tags" {
  type = map
}

variable "roboshop_db_subnet_group" {
  type = string
}