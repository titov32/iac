variable "ssh_user" {
  default = "evg"
}

variable "cloud_init_file" {
  default = "./cloud-init" # SSH-ключ через cloud-init
}

# locals {
#   dns_masters_k3s = "k3s-master.titov-ev.ru"
# }

variable "subnet_id" {
  default = "e9baq28bajv1tfvnesps"
}

variable "k3s_master_count" {
  default = 1
}

variable "k3s_worker_count" {
  default = 1
}

variable "name_prefix" {
  default = ""
}

variable "dns_masters_k3s" {
  default = "k3s-master.titov-ev.ru"
}
