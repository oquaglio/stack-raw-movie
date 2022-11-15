# Override using cmd line args or .tfvars file
#--------------------------------------------------------------
# Global Config
#--------------------------------------------------------------

# Variables used in the global config

variable "region" {
  description = "The AWS region we want to build this stack in"
  default     = "ap-southeast-2"
}

variable "availability_zones" {
  description = "Geographically distanced areas inside the region"

  default = {
    "0" = "ap-southeast-2a"
    "1" = "ap-southeast-2b"
    "2" = "ap-southeast-2c"
  }
}

variable "stack_name" {
  description = "The name of our application"
  default     = "stack-raw-movie"
}

variable "owner" {
  description = "A group email address to be used in tags"
  default     = "test@email.com"
}

variable "environment" {
  description = "Used for seperating terraform backends and naming items"
  default     = "dev"
}


#--------------------------------------------------------------
# Snowflake#
#--------------------------------------------------------------

variable "snowflake_user" {
  description = ""
}

variable "snowflake_role" {
  description = ""
}

variable "snowflake_private_key_path" {
  description = ""
}

variable "snowflake_account" {
  description = ""
}

variable "snowflake_region" {
  description = ""
}

variable "snowflake_warehouse" {
  description = ""
}

variable "snowflake_warehouse_size" {
  description = ""
}
