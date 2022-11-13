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

resource "aws_lambda_function" "terraform_lambda_func" {
  filename      = "${path.module}/files/data_loader.py.zip"
  function_name = "${var.stack_name}-data-loader-lambda-function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "data_loader.lambda_handler"
  runtime       = "python3.9"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  tags          = local.tags
}
