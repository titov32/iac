terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

# ----------------------------
# Master (4 CPU)
# ----------------------------
resource "yandex_compute_instance" "master" {
  name = "master"

  resources {
    cores         = 4
    memory        = 4
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = "fd85hkli5dp6as39ali4" # ubuntu-2404-lts
      size     = 10
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    user-data = file(var.cloud_init_file)
  }
}

# ----------------------------
# workers (2 CPU, count = 2)
# ----------------------------
resource "yandex_compute_instance" "workers" {
  count = 1
  name  = "workers-${count.index}"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = "fd85hkli5dp6as39ali4"
      size     = 10
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    user-data = file(var.cloud_init_file)
  }
}

# ----------------------------
# Ansible Inventory
# ----------------------------
resource "local_file" "ansible_inventory" {
  content  = <<EOT
[master]
${yandex_compute_instance.master.network_interface.0.nat_ip_address} ansible_user=evg "ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'"

[workers]
%{for inst in yandex_compute_instance.workers~}
${inst.network_interface.0.nat_ip_address} ansible_user=${var.ssh_user} "ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'"
%{endfor~}

[all:vars]
master_hostname=${local.dns_master_k3s}

EOT
  filename = "${path.module}/inventory.ini"
}

# ----------------------------
# Запуск Ansible playbook
# ----------------------------
# Check that VM is ready
resource "null_resource" "wait_for_ssh" {
  depends_on = [
    yandex_compute_instance.master,
    yandex_compute_instance.workers
  ]

  provisioner "local-exec" {
    command = <<EOT
    for ip in ${yandex_compute_instance.master.network_interface.0.nat_ip_address} %{for inst in yandex_compute_instance.workers~}${inst.network_interface.0.nat_ip_address} %{endfor~}; do
      echo "⏳ Жду пока $ip откроет порт 22..."
      while ! nc -z -w5 $ip 22; do sleep 5; done
    done
    EOT
  }
}

resource "null_resource" "run_ansible" {
  depends_on = [
    null_resource.wait_for_ssh,
    local_file.ansible_inventory
  ]

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${path.module}/inventory.ini playbook.yml"
  }
}
