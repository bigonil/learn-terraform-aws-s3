variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment tag for S3 bucket (e.g. Production, Development)"
  type        = string
  default     = "Production"
}

variable "index_document" {
  description = "The name of the index document (e.g., index.html)"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "The name of the error document (e.g., error.html)"
  type        = string
  default     = "error.html"
}

variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

variable "index_html_source" {
  description = "Path to the local index.html file"
  type        = string
  default     = "index.html"
}

variable "error_html_source" {
  description = "Path to the local error.html file"
  type        = string
  default     = "error.html"
}