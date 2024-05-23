output "instance_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.flaskServer.public_ip
}