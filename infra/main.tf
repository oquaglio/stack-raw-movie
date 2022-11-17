locals {

  bucket_postfix = "${data.aws_caller_identity.current.account_id}-${var.aws_region_code}"
  bucket_name    = "${var.stack_name}-s3-${local.bucket_postfix}-${var.environment}"

  tags = {
    stack_name  = "${var.stack_name}"
    environment = "${var.environment}"
    repository  = "https://github.com/oquaglio/stack-raw-movie"
    created_by  = "terraform"
    owner       = "${var.owner}"
  }
}
