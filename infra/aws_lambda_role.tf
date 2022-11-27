// Template for policy to allow access to bucket, logs (attached to role)
data "template_file" "lambda_policy_template" {
  template = file("${path.module}/policies/lambda_policy.json")
  vars = {
    role_name   = "${snowflake_storage_integration.integration.storage_aws_iam_user_arn}"
    bucket_name = local.bucket_name
  }
}

// Template for trust relationships for role (allows Lambda service to assume role)
data "template_file" "lambda_trust_policy_template" {
  template = file("${path.module}/policies/lambda_trust_policy.json")
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.stack_name}-lambda-policy-${var.environment}"
  description = "Policy to allow lambda to access bucket."
  policy      = data.template_file.lambda_policy_template.rendered
  tags        = local.tags
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.stack_name}-lambda-role-${var.environment}"
  description        = "Role to allow lambda to access bucket"
  assume_role_policy = data.template_file.lambda_trust_policy_template.rendered
  tags               = local.tags
}

// Attach the permission policy to the AWS Role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
