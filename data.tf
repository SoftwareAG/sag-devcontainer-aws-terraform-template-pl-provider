# We must be given the following networking information
data "aws_vpc" "reference_vpc" {
  id = var.provided_vpc_id
}


## All subnets may be referred to in the NLB if and only if they are all in different AZs
# data "aws_subnets" "reference_vpc_subnets" {
#   filter {
#     name   = "vpc-id"
#     values = [var.provided_vpc_id]
#   }
# }

# We must be given the following s3 bucket where we deposit the lb access logs
data "aws_s3_bucket" "logs_lb" {
  bucket = var.logs_lb_bucket.name
}
