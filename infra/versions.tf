terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.37.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }

    time = {
      source  = "hashicorp/time"
      version = "~> 0.7.2"
    }

    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.49.0"
    }
  }
}
