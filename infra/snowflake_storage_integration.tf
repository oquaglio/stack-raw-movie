# calculate the role ARN to get around circular dependency
locals {
  calculated_sf_iam_role_name = "${var.stack_name}-snowflake-role-${var.environment}"
  calculated_sf_iam_role_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.calculated_sf_iam_role_name}"
}

// Storage integration that assumes the AWS role created
resource "snowflake_storage_integration" "integration" {
  name    = replace(upper("${var.stack_name}_${var.aws_region_code}_s3_load_int"), "-", "_")
  comment = "Storage integration used to read files from S3 staging bucket"
  type    = "EXTERNAL_STAGE"

  enabled = true

  storage_provider = "S3"
  #storage_aws_role_arn = aws_iam_role.role_for_snowflake_load.arn
  storage_aws_role_arn = local.calculated_sf_iam_role_arn
  storage_allowed_locations = [
    "s3://${local.bucket_name}/"
  ]
}
