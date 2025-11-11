locals {
  vm = {
    "web" = {
        "name" = "netology-${ var.vpc_name }-platform-${ var.name_vm_web }"
    },
    "db" = {
        "name" = "netology-${ var.vpc_name }-platform-${ var.name_vm_db }"
    }
  }
}