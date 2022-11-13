# Data source used to retrieve the AWS account ID

data "aws_partition" "current" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}


data "archive_file" "zip_app_code" {
  type        = "zip"
  source_file = "${path.module}/../app/data_loader.py"
  output_path = "${path.module}/files/data_loader.py.zip"
}


# data "aws_db_instance" "source_database" {
#   db_instance_identifier = var.source_db_identifier
# }
