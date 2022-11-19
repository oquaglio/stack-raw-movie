#Create an encrypted bucket and restrict access from public
resource "aws_s3_bucket" "stage_bucket_load" {
  bucket        = local.bucket_name
  force_destroy = true

  tags = local.tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.stage_bucket_load.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.stage_bucket_load.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.stage_bucket_load.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "stage_bucket_load_access_block" {
  bucket = aws_s3_bucket.stage_bucket_load.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "object" {
  bucket   = aws_s3_bucket.stage_bucket_load.id
  for_each = toset(var.bucket_object_prefixes)
  key      = each.value
}
