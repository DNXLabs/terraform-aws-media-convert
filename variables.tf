variable "region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "input_bucket_name" {
  description = "Input bucket name which contains videos to be transcoded."
  type        = string
}

variable "output_bucket_name" {
  description = "Output bucket name which contains videos after transcoding."
  type        = string
}

variable "bucket_event_prefix" {
  description = "Element prefix to trigger lambda function."
  default     = "input/"
  type        = string
}

variable "bucket_event_suffix" {
  description = "Element suffix to trigger lambda function."
  default     = ".mp4"
  type        = string
}

variable "project_base_name" {
  description = "Project name."
  default     = "my_workflow_vod"
  type        = string
}

variable "mediaconvert_endpoint" {
  description = "AWS Element MediaConvert API endpoint. e.g https://abcd1234.mediaconvert.us-west-2.amazonaws.com"
  type        = string
}

variable "media_convert_config_name" {
  description = "AWS Element MediaConvert API endpoint."
  default     = "config"
  type        = string
}

variable "media_convert_config" {
  description = "AWS Element MediaConvert API endpoint."
  type        = string
}