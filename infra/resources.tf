################################################################################
# Lambda Resources
################################################################################

resource "aws_iam_role" "lambda_role" {
  name               = "${var.stack_name}-lambda-role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF

  tags = local.tags
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = "${var.stack_name}-lambda-policy"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF

  tags = local.tags
}

# attach the policy to the role
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

resource "aws_lambda_function" "movie_loader_lambda_func" {
  filename      = "${path.module}/files/movie_loader.py.zip"
  function_name = "${var.stack_name}-movie-loader-lambda-function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "movie_loader.lambda_handler"
  runtime       = "python3.9"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  tags          = local.tags
}

resource "aws_lambda_function" "movie_producer_lambda_func" {
  filename      = "${path.module}/files/movie_producer.py.zip"
  function_name = "${var.stack_name}-movie-producer-lambda-function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "movie_producer.lambda_handler"
  runtime       = "python3.9"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  tags          = local.tags
}

################################################################################
# Snowflake Resources
################################################################################

locals {
  sf_role_name = "${var.stack_name}-snowflake-int-obj-role"
  sf_role_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.sf_role_name}"
}

# Storage integration object
# Note: the arn for the IAM role is pre-calculated to get around
# the apparent circular dependency
resource "snowflake_storage_integration" "snowflake_int_obj" {
  name    = "S3_STORAGE_INT"
  comment = "Storage integration for RDS data loading from AWS"
  type    = "EXTERNAL_STAGE"

  enabled = true

  storage_allowed_locations = ["s3://${local.bucket_name}/"]
  #   storage_blocked_locations = [""]
  #   storage_aws_object_acl    = "bucket-owner-full-control"

  storage_provider = "S3"
  #storage_aws_external_id  = "..."
  #storage_aws_iam_user_arn = "..."
  storage_aws_role_arn = local.sf_role_arn
}

resource "aws_iam_policy" "bucket_policy" {
  name        = "${var.stack_name}-bucket-policy"
  path        = "/"
  description = "Allow "

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "arn:aws:s3:::*/*",
          "arn:aws:s3:::${local.bucket_name}"
        ]
      }
    ]
  })
}

#
# Role to allow integration object access to the S3 bucket
resource "aws_iam_role" "iam_int_obj_role" {
  name = local.sf_role_name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : snowflake_storage_integration.snowflake_int_obj.storage_aws_iam_user_arn
        },
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "StringEquals" : {
            "sts:ExternalId" : snowflake_storage_integration.snowflake_int_obj.storage_aws_external_id
          }
        }
      }
    ]
  })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "bucket_policy_attachment" {
  role       = aws_iam_role.iam_int_obj_role.name
  policy_arn = aws_iam_policy.bucket_policy.arn
}

resource "snowflake_warehouse" "warehouse" {
  name           = var.snowflake_warehouse
  warehouse_size = var.snowflake_warehouse_size

  auto_suspend = 60
}

resource "snowflake_database" "sf_dev_db" {
  name                        = "DEV"
  comment                     = "DEV database"
  data_retention_time_in_days = 3
}

resource "snowflake_schema" "sf_schema" {
  database = snowflake_database.sf_dev_db.name
  name     = "RAW_MOVIE"
  comment  = "Schema for RAW movie data"

  is_transient        = false
  is_managed          = false
  data_retention_days = 1
}

resource "snowflake_file_format" "json_file_format" {
  name              = "JSON_FILE_FORMAT"
  database          = snowflake_database.sf_dev_db.name
  schema            = snowflake_schema.sf_schema.name
  format_type       = "JSON"
  binary_format     = "HEX"
  compression       = "AUTO"
  strip_outer_array = true
}

resource "snowflake_stage" "s3_stage" {
  name                = "S3_STAGE"
  url                 = "s3://${local.bucket_name}/"
  database            = snowflake_database.sf_dev_db.name
  schema              = snowflake_schema.sf_schema.name
  storage_integration = snowflake_storage_integration.snowflake_int_obj.name
  file_format         = "format_name = ${snowflake_database.sf_dev_db.name}.${snowflake_schema.sf_schema.name}.${snowflake_file_format.json_file_format.name}"
}
