variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Folder ID"
  type        = string
}

variable "yc_token" {
  description = "Yandex Cloud token"
  type        = string
}

# variable "sa_key_file" {
#   description = "./key.json"
#   type        = string
# }

variable "bucket_name" {
  description = "Bucket name for Terraform state"
  type        = string
  default     = "titov-ev-terraform-state-bucket"
}
