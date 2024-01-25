output "resolved_vpc" {
  description = "VPC resolved from the given data var.provided_vpc_id"
  value       = data.aws_vpc.reference_vpc
}

output "given_s3_bucket" {
  description = "S3 bucket given as input"
  value       = data.aws_s3_bucket.logs_lb
}
