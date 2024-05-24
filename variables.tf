variable "ami_id" {
  description = "ID of the AMI to use"
  type        = string
}

variable "instance_type" {
  description = "Type of instance to use"
  type        = string
  default     = "t2.micro"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  type = string
}

variable "public_subnet_cidr" {
  description = "Cidr for public subnet"
  type = string
}