# Project metadata
project_name = "test-project-pl-c-01"

# TODO: restrict to 
deployment_region = "eu-central-1"


provided_meta_tags = {
  environment_type        = "development"
  deployment_discriminant = "mi-01"
}

# Provisioning prerequisites

## What is the VPC of interest for the private link?
provided_vpc_id = "vpc-000111"

provided_lb_subnet_ids = ["subnet-000111"]

## Where are we going to deposit the NLB logs?
logs_lb_bucket = "valdoridex-logs-bucket"

## What is the ARN of the principal that will be allowed to access the NLB?
allowed_principals = [
  "arn:aws:iam::1111:root",
  "arn:aws:iam::2222:root"
]

