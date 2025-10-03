terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  backend "s3" {
    bucket = "titov-ev-terraform-state-bucket"
    key    = "terraform.tfstate"
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    region                      = "ru-central1"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # Необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.

  }
  required_version = ">= 0.13"
}


provider "yandex" {
  zone                     = "ru-central1-a"
  cloud_id                 = local.cloud_id
  folder_id                = local.folder_id
  service_account_key_file = "key.json"
}

module "k3s_cluster" {
  providers = {
    yandex = yandex
  }
  source           = "./modules/k3s" # локальный путь
  k3s_master_count = 1
  k3s_worker_count = 1
}
