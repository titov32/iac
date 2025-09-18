# 1. Создаём DNS-зону
resource "yandex_dns_zone" "titov_ev" {
  name        = "titov-ev"
  zone        = "titov-ev.ru."
  public      = true
  description = "Terraform managed zone"
}

# 2. Создаём A-записи для поддомена app.titov-ev.ru на каждую ноду
resource "yandex_dns_recordset" "app_nodes" {
  zone_id = yandex_dns_zone.titov_ev.id
  name    = "app.titov-ev.ru."
  type    = "A"
  ttl     = 300

  data = concat(
    [yandex_compute_instance.master.network_interface[0].nat_ip_address],
    [for w in yandex_compute_instance.workers : w.network_interface[0].nat_ip_address]
  )
}
