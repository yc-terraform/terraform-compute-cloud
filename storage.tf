
resource "yandex_compute_disk" "this" {
  name        = var.name
  description = var.description
  folder_id   = local.folder_id
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