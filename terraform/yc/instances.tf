# ----------------------------
# Master (4 CPU)
# ----------------------------
resource "yandex_compute_instance" "master" {
  name = "master"

  resources {
    cores  = 4
    memory = 4
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
# workers (2 CPU, count = 2)
# ----------------------------
resource "yandex_compute_instance" "workers" {
  count = 2
  name  = "workers-${count.index}"

  resources {
    cores  = 2
    memory = 2
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
# ${yandex_compute_instance.master.network_interface.0.nat_ip_address} ansible_user=${var.ssh_user}
${yandex_compute_instance.master.network_interface.0.nat_ip_address} ansible_user=evg "ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'"

[workers]
%{for inst in yandex_compute_instance.workers~}
# ${inst.network_interface.0.nat_ip_address} ansible_user=${var.ssh_user}
${inst.network_interface.0.nat_ip_address} ansible_user=evg "ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'"
%{endfor~}
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
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ./inventory.ini playbook.yml"
  }
}

# outputs.tf
output "vm_public_ip" {
  description = "Public IP address of the Yandex Compute Instance"
  value       = yandex_compute_instance.master.network_interface[0].nat_ip_address
}

output "vm_private_ip" {
  description = "Private IP address of the Yandex Compute Instance"
  value       = yandex_compute_instance.master.network_interface[0].ip_address
}

output "vm_fqdn" {
  description = "FQDN of the Compute Instance"
  value       = yandex_compute_instance.master.fqdn
}

output "vm_fqdns_count" {
  description = "FQDNs всех ВМ через count"
  value       = [for i, vm in yandex_compute_instance.workers : vm.fqdn]
}
