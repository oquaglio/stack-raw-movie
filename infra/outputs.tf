#--------------------------------------------------------------
# Global Config
#--------------------------------------------------------------

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "s3_bucket_name" {
  description = "Name of bucket"
  value       = module.s3_bucket.s3_bucket_id
}
