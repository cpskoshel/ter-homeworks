resource "yandex_compute_disk" "storage_disks" {
  count = 3

  name = "storage-disk-${count.index}"
  type = "network-hdd"
  zone = "ru-central1-a" 
  size = 1 
}

resource "yandex_compute_instance" "storage_vm" {
  name = "storage"
  zone = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204_lts.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  scheduling_policy { preemptible = true }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disks[*].id

    content {
      disk_id = secondary_disk.value
    }
  }

  metadata = {
    #ssh-keys           = "nik:${local.ssh-keys}"
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }
}

output "disk_ids" {
  value = yandex_compute_disk.storage_disks[*].id
}

output "dis" {
  value = yandex_compute_instance.storage_vm[*]
}

output "dis2" {
  value = length(yandex_compute_instance.web_vm[*])
}

output "dis3" {
  value = length(yandex_compute_instance.db_instances[*])
}
