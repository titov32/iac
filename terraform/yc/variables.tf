locals {
  folder_id      = "b1g8a9969382h9etpd6f"
  cloud_id       = "b1g6901na401beivif4k"
  dns_master_k3s = "k3s-master.titov-ev.ru"
}

variable "subnet_id" {
  default = "e9baq28bajv1tfvnesps"
}

variable "cloud_init_file" {
  default = "/disk/iac/terraform/yc/cloud-init" # SSH-ключ через cloud-init
}

variable "ssh_user" {
  default = "evg"
}

# variable "cloud_id" {
#   description = "Yandex Cloud ID"
#   type        = string
# }

# variable "folder_id" {
#   description = "Yandex Folder ID"
#   type        = string
# }

# variable "yc_token" {
#   description = "Yandex Cloud token"
#   type        = string
# }


variable "bucket_name" {
  description = "Bucket name for Terraform state"
  type        = string
  default     = "titov-ev-terraform-state-bucket"
}
