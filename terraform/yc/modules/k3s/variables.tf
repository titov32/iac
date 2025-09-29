variable "ssh_user" {
  default = "evg"
}

variable "cloud_init_file" {
  default = "/disk/iac/terraform/yc/cloud-init" # SSH-ключ через cloud-init
}

locals {
  dns_master_k3s = "k3s-master.titov-ev.ru"
}

variable "subnet_id" {
  default = "e9baq28bajv1tfvnesps"
}
