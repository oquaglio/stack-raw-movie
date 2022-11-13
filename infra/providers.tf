provider "aws" {
  region = var.region
}

provider "random" {}

provider "time" {}

provider "snowflake" {
  // required
  username         = var.snowflake_user
  account          = var.snowflake_account
  region           = var.snowflake_region
  private_key_path = var.snowflake_private_key_path

  // optional, at exactly one must be set
  #password = var.snowflake_password

  #warehouse = var.snowflake_warehouse
}
