variable "vm_web_compute_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "The name of the image family to which this image belongs."
}

variable "name_vm_web" {
    type = string
    default = "web"
}

variable "name_vm_db" {
    type = string
    default = "db"
} 

variable "vm_web_compute_instance" {
  type = object({
    name        = string
    platform_id = string
    resources   = map(number)
    preemptible = bool
  })
  default = {
    name        = "netology-develop-platform-web"
    platform_id = "standard-v4a"
    resources = {
      "cores"          = 2
      "memory"         = 1
      "core_fraction"  = 20
    }
    preemptible = true
  }
  description = "A VM instance resource"
}

variable "vm_db_compute_instance" {
  type = object({
    name        = string
    platform_id = string
    resources   = map(number)
    preemptible = bool
    zone        = string
  })
  default = {
    name        = "netology-develop-platform-db"
    platform_id = "standard-v4a"
    resources = {
      "cores"          = 2
      "memory"         = 2
      "core_fraction"  = 20
    }
    preemptible = true
    zone        = "ru-central1-b"
  }
  description = "A VM instance resource"
}

variable "metadata" {
    type = map(object({
    serial-port-enable = number
    ssh-keys            = string
  }))
  default = {
    resource_metadata = {
        serial-port-enable = 1
        ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJwunbvK1A7V1w69Uxc58JMG+GnHYa88VMoai4HQgclv koshel_np@MacBook-Pro-Apple.local"
    }
  }
}