### Datasource
data "yandex_client_config" "client" {}

### Locals
locals {
  folder_id = var.folder_id == null ? data.yandex_client_config.client.folder_id : var.folder_id

}
# Add the image_family variable to the data source for the image
data "yandex_compute_image" "this" {
  family = var.image_family
}

# Add the is_nat variable to the network_interface block
resource "yandex_compute_instance" "this" {
  name               = var.name
  platform_id        = var.platform_id
  zone               = var.zone
  description        = var.description
  hostname           = var.hostname
  folder_id          = local.folder_id
  service_account_id = var.service_account_id
  labels             = var.labels
  metadata           = var.metadata
  allow_stopping_for_update = var.allow_stopping_for_update
  network_acceleration_type = var.network_acceleration_type
  gpu_cluster_id     = var.gpu_cluster_id
  metadata_options   = var.metadata_options
  maintenance_policy = var.maintenance_policy
  maintenance_grace_period = var.maintenance_grace_period

  resources {
    cores         = var.cores
    memory        = var.memory
    core_fraction = var.core_fraction
    dynamic "gpus" {
      for_each = var.gpus != null ? [1] : []
      content {
        count = var.gpus
      }
    }
  }

  boot_disk {
    auto_delete = var.boot_disk_auto_delete
    device_name = var.boot_disk_device_name
    mode        = var.boot_disk_mode
    disk_id     = var.boot_disk_disk_id

    initialize_params {
      name        = var.boot_disk_name
      description = var.boot_disk_description
      size        = var.boot_disk_size
      block_size  = var.boot_disk_block_size
      type        = var.boot_disk_type
      image_id    = var.boot_disk_image_id
      snapshot_id = var.boot_disk_snapshot_id
    }
  }

  network_interface {
    subnet_id          = var.subnet_id
    index              = var.network_interface_index
    ipv4               = var.network_interface_ipv4
    ip_address         = var.network_interface_ip_address
    ipv6               = var.network_interface_ipv6
    ipv6_address       = var.network_interface_ipv6_address
    nat                = var.is_nat
    nat_ip_address     = var.network_interface_nat_ip_address
    security_group_ids = var.network_interface_security_group_ids

    dns_record {
      fqdn        = var.network_interface_dns_record_fqdn
      dns_zone_id = var.network_interface_dns_record_dns_zone_id
      ttl         = var.network_interface_dns_record_ttl
      ptr         = var.network_interface_dns_record_ptr
    }

    ipv6_dns_record {
      fqdn        = var.network_interface_ipv6_dns_record_fqdn
      dns_zone_id = var.network_interface_ipv6_dns_record_dns_zone_id
      ttl         = var.network_interface_ipv6_dns_record_ttl
      ptr         = var.network_interface_ipv6_dns_record_ptr
    }

    nat_dns_record {
      fqdn        = var.network_interface_nat_dns_record_fqdn
      dns_zone_id = var.network_interface_nat_dns_record_dns_zone_id
      ttl         = var.network_interface_nat_dns_record_ttl
      ptr         = var.network_interface_nat_dns_record_ptr
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
    placement_group_id  = var.placement_policy_placement_group_id
    host_affinity_rules = var.placement_policy_host_affinity_rules
  }

  dynamic "local_disk" {
    for_each = var.local_disks != null ? [for l in var.local_disks : l] : []
    content {
      size_bytes = local_disk.value.size_bytes
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
