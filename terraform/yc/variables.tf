locals {
  folder_id = "b1g8a9969382h9etpd6f"
  cloud_id  = "b1g6901na401beivif4k"
}


variable "bucket_name" {
  description = "Bucket name for Terraform state"
  type        = string
  default     = "titov-ev-terraform-state-bucket"
}
