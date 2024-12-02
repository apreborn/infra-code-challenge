variable "region" {
  description = "AWS region to deploy the resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Unique name for the S3 bucket"
  type        = string
}

variable "tags" {
  description = "Tags for AWS resources"
  type        = map(string)
  default     = {
    Environment = "Dev"
    Owner       = "Robin Singh"
  }
}
