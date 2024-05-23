variable "ami_id" {
  description = "ID of the AMI to use"
  type        = string
}

variable "instance_type" {
  description = "Type of instance to use"
  type        = string
  default     = "t2.micro"
}

variable "vpc_id" {
  description = "VPC ID for the security group"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}