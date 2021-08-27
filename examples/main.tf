provider "aws" {
  region = "us-east-1"
}

module "workflow_vod" {
  source = "../."

  region                    = "us-east-1"
  input_bucket_name         = "my_input_bucket_name"
  output_bucket_name        = "my_output_bucket_name"
  project_base_name         = "converter"
  bucket_event_prefix       = "input/"
  bucket_event_suffix       = ".mp4"
  mediaconvert_endpoint     = "https://abcd1234.mediaconvert.us-west-2.amazonaws.com"
  media_convert_config_name = "config"
  media_convert_config      = data.template_file.json_template.rendered
}

data "template_file" "json_template" {
  template = file("job.json")
  vars = {
    destination_s3 = "dnx-chime-transcoder"
  }
}