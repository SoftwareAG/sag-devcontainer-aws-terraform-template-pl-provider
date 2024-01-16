variable "project_name" {
  type    = string
  default = "pl-p-01"
}

variable "deployment_regions_list" {
  type    = list(string)
  default = ["eu-central-1"]
}

variable "provided_meta_tags" {
  type = map(string)
  default = {
    "environment_type" = "development"
  }
}

variable "provided_vpc_id" {
  type    = string
  default = "You must provide a vpc id here!"
}

variable "logs_lb_bucket" {
  type    = string
  default = "bucket.test.com"
}
