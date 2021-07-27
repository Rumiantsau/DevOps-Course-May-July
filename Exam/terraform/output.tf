output "alb_dns_go_port_8080" {
  value       = aws_lb.rumiantsau_alb_go.dns_name
  description = "The alb go DNS name"
}

output "alb_dns_python_port_8181" {
  value       = aws_lb.rumiantsau_alb_python.dns_name
  description = "The alb go DNS name"
}