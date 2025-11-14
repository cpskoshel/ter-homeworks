variable "each_vm" {
  description = "Configuration for each VM (main and replica)"
  type = map(object({
    cpu           = number
    ram           = number
    disk_volume   = number
    core_fraction = number
  }))
  default = {
    main = {
      cpu           = 4
      ram           = 8
      disk_volume   = 40
      core_fraction = 20
    }
    replica = {
      cpu           = 2
      ram           = 4
      disk_volume   = 20
      core_fraction = 20
    }
  }
}

resource "yandex_compute_instance" "db_instances" {
  for_each = var.each_vm

  name = "db-${each.key}"
  zone = "ru-central1-a"

  resources {
    cores  = each.value.cpu
    memory = each.value.ram
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      size     = each.value.disk_volume
    }
  }

  metadata = {
    #ssh-keys           = "nik:${local.ssh-keys}"
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
}