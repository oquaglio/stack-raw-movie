

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

provider "random" {}

provider "snowflake" {
  username         = var.snowflake_account_param["user"]
  account          = var.snowflake_account_param["account"]
  region           = var.snowflake_account_param["region"]
  private_key_path = var.snowflake_account_param["private_key_path"]
  #warehouse = var.snowflake_warehouse
}
