locals {
  project_tags = merge(var.provided_meta_tags, {
    project_name = var.project_name
  })
}

# A Private link must have an endpoint service
resource "aws_vpc_endpoint_service" "pl-endpoint-service" {

  # Design choice. If not explictly specified for good reasons, leave this on true (also see checkov CKV_AWS_123)
  # https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-networking-policies/ensure-that-vpc-endpoint-service-is-configured-for-manual-acceptance
  acceptance_required = true

  # which load balancers are hosting the endpoint service?
  network_load_balancer_arns = [aws_lb.pl-lb.arn]

  tags = merge(local.project_tags, { Name = "pl-endpoint-service" })
}

# A Private link must explicitly associate and allowed principal in order to be accessible
resource "aws_vpc_endpoint_service_allowed_principal" "pl-endpoint_control" {

  # which accounts are allowed to use this endpoint service?
  # this is a list of account numbers
  for_each = toset(var.allowed_principals)
  # which endpoint service are we managing?
  vpc_endpoint_service_id = aws_vpc_endpoint_service.pl-endpoint-service.id

  principal_arn = each.value
}


# In our case we also manage the load balancer that hosts the endpoint service
resource "aws_lb" "pl-lb" {
  name = "pl-lb"

  # Load balancer is supposed to be private, otherwise private links may not be useful
  internal = true

  # wmio does not offer gateway lbs, therefore this is always "network" or "application"
  load_balancer_type = "network"

  # design option. Should be set to true.
  enable_deletion_protection = true

  # design decision. by default we assume (1) the customer's VPC already and (2) we map all its subnets
  # it is likely that the customer will ask to map a chosen subset of the subnets
  subnets = var.provided_lb_subnet_ids

  # design decision. Recommended to use multiple AZs, therefore keep this on true accordingly
  enable_cross_zone_load_balancing = true

  # design decision according to customer's needs 
  # define security groups accordingly
  security_groups = [aws_security_group.pl-lb-sg01.id]

  # highly recommended design decision: enable access_logs. These are useful for security, monitoring and troubleshooting purposes
  access_logs {
    enabled = true
    prefix  = "valdoridex/load-balancers/pl-lb"
    bucket  = data.aws_s3_bucket.logs_lb.id
  }

  tags = merge(local.project_tags, { Name = "pl-lb" })

}

# design decision. This is an example on how to open the default https port
resource "aws_security_group" "pl-lb-sg01" {
  # checkov:skip=CKV2_AWS_5: Resolve this for production according to the balanced resources
  name        = "pl-lb-sg01"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.reference_vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.reference_vpc.cidr_block]
  }

  tags = merge(var.provided_meta_tags, { Name = "pl-lb-sg01" })
}

######## LB must access the S3 bucket in order to log

## TODO: ensure the policies allow the load balancer to produce logs in the S3 bucket
## WIP: (e.g. ) https://github.com/trussworks/terraform-aws-logs/
