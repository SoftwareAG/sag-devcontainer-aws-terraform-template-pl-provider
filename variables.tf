# Project metadata
variable "project_name" {
  type    = string
  default = "pl-p-01"
}

# Tags that are propagate to all relevant project resources
variable "provided_meta_tags" {
  type = map(string)
  default = {
    environment_type = "development"
    # This tag is usefult to give a hint on what piece of terraform state manages this project
    tf_state_discriminant = "pl-p-01"
  }
}

# In what region will the private link be hosted?
variable "deployment_region" {
  type    = string
  default = "eu-central-1"
}

# Provisioning prerequisites

## What is the VPC of interest for the private link on the provider side?
variable "provided_vpc_id" {
  type    = string
  default = "You must provide a vpc id here!"
}

## What is the VPC of interest for the private link on the provider side?
variable "provided_lb_subnet_ids" {
  type    = list(string)
  default = [
    "subnet-1111",
    "subnet-2222"
  ]
}


## Where are we going to deposit the NLB logs?
## We must be given an s3 bucket
## TODO: add an option to generate it if not given
variable "logs_lb_bucket" {
  type    = string
  default = "bucket.test.com"
}

variable "allowed_principals" {
  type = list(string)
  default = [
    "arn:aws:iam::some_account_id:root",
    "arn:aws:iam::some_other_account_id:root"
  ]
}

# ## What is the ARN of the principal that will be allowed to access the NLB?
# variable "allowed_principal_arn_01" {
#   type    = string
#   default = "arn:aws:iam::some_account_id:root"
# }

# variable "allowed_principal_arn_02" {
#   type    = string
#   default = "arn:aws:iam::some_other_account_id:root"
# }
