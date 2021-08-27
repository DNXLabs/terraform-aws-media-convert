resource "local_file" "this" {
  content  = var.media_convert_config
  filename = "${path.module}/mediaconvert_lambda/job.json"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/mediaconvert_lambda"
  output_path = "${path.module}/mediaconvert_lambda.zip"

  depends_on = [
    local_file.this
  ]
}

resource "aws_lambda_function" "this" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.project_base_name}-lambda"
  role             = aws_iam_role.lambda_job.arn
  handler          = "mediaconvert.convert_video"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "python3.8"
  timeout          = 60

  environment {
    variables = {
      REGION                = var.region,
      OUTPUT_BUCKET         = var.output_bucket_name,
      MEDIACONVERT_ROLE_ARN = aws_iam_role.mediaconvert_job.arn,
      MEDIACONVERT_ENDPOINT = var.mediaconvert_endpoint,
      MEDIACONVERT_CONFIG   = "/mediaconvert/${var.media_convert_config_name}"
    }
  }
}

resource "aws_lambda_permission" "allow_bucket" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.arn
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.input_bucket_name}"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.input_bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.this.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = var.bucket_event_prefix
    filter_suffix       = var.bucket_event_suffix
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}
