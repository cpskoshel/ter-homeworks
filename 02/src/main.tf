resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone 
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

resource "yandex_vpc_subnet" "db" {
  name           = var.name_vm_db
  zone           = var.vm_db_compute_instance.zone 
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.zone_b_cidr
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_compute_image_family
}
resource "yandex_compute_instance" "platform" {
  name        = local.vm.web.name
  platform_id = var.vm_web_compute_instance.platform_id

  resources {
    cores         = var.vm_web_compute_instance.resources.cores
    memory        = var.vm_web_compute_instance.resources.memory
    core_fraction = var.vm_web_compute_instance.resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_compute_instance.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = var.metadata.resource_metadata
}

resource "yandex_compute_instance" "db" {
  name        = local.vm.db.name
  platform_id = var.vm_db_compute_instance.platform_id
  zone        = var.vm_db_compute_instance.zone

  resources {
    cores         = var.vm_db_compute_instance.resources.cores
    memory        = var.vm_db_compute_instance.resources.memory
    core_fraction = var.vm_db_compute_instance.resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_compute_instance.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.db.id
    nat       = true
  }

  metadata = var.metadata.resource_metadata
}
