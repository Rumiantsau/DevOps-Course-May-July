output "bastion_host_ip_address" {
  value       = aws_instance.rumiantsau_environment_bastion_instance.public_ip
  description = "The ip address of the bastion host"
}
output "app_host_ip_address" {
  value       = aws_instance.rumiantsau_environment_empty_instance.*.private_ip
  description = "The ip address of the app hosts"
}
output "alb_dns" {
  value       = aws_lb.rumiantsau_environment_alb.dns_name
  description = "The alb DNS name"
}
