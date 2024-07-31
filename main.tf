### Datasource
data "yandex_client_config" "client" {}

### Locals
locals {
  folder_id = var.folder_id == null ? data.yandex_client_config.client.folder_id : var.folder_id
}

data "yandex_compute_image" "image" {
  family = var.image_family
  count = var.image_family != null ? 1 : 0
}
resource "yandex_compute_disk" "this" {
  name        = var.name
  description = var.description
  folder_id   = var.folder_id
  labels      = var.labels
  zone        = var.zone
  size        = var.size
  block_size  = var.block_size
  type        = var.type
  image_id    = var.image_family != null ? data.yandex_compute_image.image[0].id : var.image_id
  snapshot_id = var.snapshot_id

  dynamic "disk_placement_policy" {
    for_each = var.disk_placement_policy != null ? [var.disk_placement_policy] : []
    content {
      disk_placement_group_id = disk_placement_policy.value.disk_placement_group_id
    }
  }
}
resource "yandex_vpc_address" "static_ip" {
  count = var.static_ip != null ? 1 : 0
  name                      = var.static_ip.name
  description               = var.static_ip.description
  folder_id                 = var.static_ip.folder_id
  labels                    = var.static_ip.labels
  deletion_protection       = var.static_ip.deletion_protection

  external_ipv4_address {
    zone_id                   = var.static_ip.external_ipv4_address.zone_id
    ddos_protection_provider  = var.static_ip.external_ipv4_address.ddos_protection_provider
    outgoing_smtp_capability  = var.static_ip.external_ipv4_address.outgoing_smtp_capability
  }

  dynamic "dns_record" {
    for_each = var.static_ip.dns_record != null ? [var.static_ip.dns_record] : []
    content {
      fqdn        = dns_record.value.fqdn
      dns_zone_id = dns_record.value.dns_zone_id
      ttl         = lookup(dns_record.value, "ttl", null)
      ptr         = lookup(dns_record.value, "ptr", false)
    }
  }
}


resource "yandex_compute_instance" "this" {
  name               = var.name
  platform_id        = var.platform_id
  zone               = var.zone
  description        = var.description
  hostname           = var.hostname
  folder_id          = local.folder_id
  service_account_id = var.service_account_id
  labels             = var.labels
  metadata = merge(var.enable_oslogin_or_ssh_keys, var.custom_metadata, var.serial_port_enable ? {"serial-port-enable" = "1"} : {})

  allow_stopping_for_update = var.allow_stopping_for_update
  network_acceleration_type = var.network_acceleration_type
  gpu_cluster_id     = var.gpu_cluster_id
  maintenance_policy = var.maintenance_policy
  maintenance_grace_period = var.maintenance_grace_period
  resources {
    cores         = var.cores
    core_fraction = var.core_fraction
    memory        = var.memory
    gpus          = var.gpus
  }
  boot_disk {
    auto_delete = var.boot_disk_auto_delete
    device_name = var.boot_disk_device_name
    mode        = var.boot_disk_mode
    disk_id     = yandex_compute_disk.this != null ? yandex_compute_disk.this.id : var.boot_disk_disk_id

    initialize_params {
      name        = yandex_compute_disk.this != null ? yandex_compute_disk.this.name : var.boot_disk_name
      description = yandex_compute_disk.this != null ? yandex_compute_disk.this.description : var.boot_disk_description
      size        = yandex_compute_disk.this != null ? yandex_compute_disk.this.size : var.boot_disk_size
      block_size  = yandex_compute_disk.this != null ? yandex_compute_disk.this.block_size : var.boot_disk_block_size
      type        = yandex_compute_disk.this != null ? yandex_compute_disk.this.type : var.boot_disk_type
      image_id    = yandex_compute_disk.this != null ? yandex_compute_disk.this.image_id : var.boot_disk_image_id
      snapshot_id = yandex_compute_disk.this != null ? yandex_compute_disk.this.snapshot_id : var.boot_disk_snapshot_id
    }
  }
  dynamic "network_interface" {
    for_each = var.network_interfaces
    content {
      subnet_id          = network_interface.value.subnet_id
      index              = lookup(network_interface.value, "index", null)
      ipv4               = lookup(network_interface.value, "ipv4", false)
      ip_address         = lookup(network_interface.value, "ip_address", null)
      nat                = lookup(network_interface.value, "nat", false)
      nat_ip_address     = lookup(network_interface.value, "ipv4", false) && var.static_ip != null ? yandex_vpc_address.static_ip[0].id : null

      security_group_ids = lookup(network_interface.value, "security_group_ids", null)

      dynamic "dns_record" {
        for_each = lookup(network_interface.value, "dns_record", [])
        content {
          fqdn        = dns_record.value.fqdn
          dns_zone_id = lookup(dns_record.value, "dns_zone_id", null)
          ttl         = lookup(dns_record.value, "ttl", null)
          ptr         = lookup(dns_record.value, "ptr", false)
        }
      }
    }
  }


  dynamic "secondary_disk" {
    for_each = var.secondary_disks != null ? [for s in var.secondary_disks : s] : []
    content {
      disk_id     = secondary_disk.value.disk_id
      auto_delete = secondary_disk.value.auto_delete
      device_name = secondary_disk.value.device_name
      mode        = secondary_disk.value.mode
    }
  }

  scheduling_policy {
    preemptible = var.scheduling_policy_preemptible
  }

  placement_policy {
    placement_group_id = var.placement_policy.placement_group_id

    dynamic "host_affinity_rules" {
      for_each = var.placement_policy.host_affinity_rules != null ? [for r in var.placement_policy.host_affinity_rules : r] : []
      content {
        key    = host_affinity_rules.value.key
        op     = host_affinity_rules.value.op
        values = host_affinity_rules.value.values
      }
    }
  }



  dynamic "filesystem" {
    for_each = var.filesystems != null ? [for f in var.filesystems : f] : []
    content {
      filesystem_id = filesystem.value.filesystem_id
      device_name   = filesystem.value.device_name
      mode          = filesystem.value.mode
    }
  }
}
