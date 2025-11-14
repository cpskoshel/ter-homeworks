

resource "local_file" "hosts_for" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      webservers = yandex_compute_instance.web_vm
      databases  = yandex_compute_instance.db_instances
      storage    = [yandex_compute_instance.storage_vm]
    }
  )
  filename = "${abspath(path.module)}/for.ini"
}