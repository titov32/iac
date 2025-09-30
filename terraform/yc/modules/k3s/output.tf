# outputs.tf
output "vm_public_ip" {
  description = "Public IP address of the Yandex Compute Instance"
  value       = [for i, vm in yandex_compute_instance.masters : vm.network_interface[0].nat_ip_address]
}

output "vm_private_ip" {
  description = "Private IP address of the Yandex Compute Instance"

  value = [for i, vm in yandex_compute_instance.masters : vm.network_interface[0].ip_address]
}

output "vm_fqdns_count" {
  description = "FQDNs всех ВМ через count"
  value       = [for i, vm in yandex_compute_instance.workers : vm.fqdn]
}
