output "resolved_vpc" {
  description = "VPC resolved from the given data var.provided_vpc_id"
  value       = data.aws_vpc.reference_vpc
}
