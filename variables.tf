variable "my_ip" {
  description = "Your public IP address, used to restrict SSH access to the web security group"
  type        = string
}

variable "s3_bucket_name" {
  description = "Globally unique name for the S3 assets bucket"
  type        = string
}
variable "project_name" {
  description = "Project name used for tagging and resource naming at the root level"
  type        = string
}
variable "key_name" {
  description = "Name of the AWS key pair for SSH access to the web server"
  type        = string
}