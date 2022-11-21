# Override using cmd line args or .tfvars file
#--------------------------------------------------------------
# Global Config
#--------------------------------------------------------------

# Variables used in the global config

variable "aws_profile" {
  description = "Profile to use to authenticate to  AWS"
  type        = string
}

variable "aws_account_id" {
  description = "Profile to use to authenticate to  AWS"
  type        = string
}

variable "aws_region" {
  description = "The AWS region we want to build this stack in"
  type        = string
  default     = "ap-southeast-2"
}

variable "aws_region_code" {
  description = "The AWS region we want to build this stack in"
  type        = string
}

variable "stack_name" {
  description = "The name of our application"
  type        = string
  default     = "stack-raw-movie"
}

variable "owner" {
  description = "A group email address to be used in tags"
  type        = string
  default     = "test@email.com"
}

variable "environment" {
  description = "Used for seperating terraform backends and naming items"
  type        = string
  default     = "dev"
}

# Bucket

variable "bucket_object_prefixes" {
  description = "List of bucket object prefixes to create"
  type        = set(string)
  default     = ["movies/", "directors/", "actors/", "movies2/"]
}

#--------------------------------------------------------------
# Snowflake#
#--------------------------------------------------------------

variable "snowflake_account_param" {
  type = map(string)
  default = {
    account          = ""
    region           = ""
    role             = ""
    user             = ""
    private_key_path = ""
  }
}

variable "snowflake_warehouse" {
  description = ""
}

variable "snowflake_warehouse_size" {
  description = ""
}

variable "snowflake_account_arn" {
  description = "Snowflake's account ARN"
  type        = string
}

variable "snowflake_external_id" {
  description = "Snowflake's external id"
  type        = string
}
