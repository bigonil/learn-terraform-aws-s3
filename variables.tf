# variables.tf

variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = false  # Set to false by default, can override when applying
}