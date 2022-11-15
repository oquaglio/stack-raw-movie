locals {

  bucket_postfix = "${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  bucket_name    = "${var.stack_name}-s3-${var.environment}-${local.bucket_postfix}"

  tags = {
    stack_name  = "${var.stack_name}"
    environment = "${var.environment}"
    repository  = "https://github.com/oquaglio/stack-raw-movie"
    created_by  = "terraform"
  }
}

################################################################################
# S3
################################################################################

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.1"

  bucket = local.bucket_name

  attach_deny_insecure_transport_policy = false

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = local.tags
}
