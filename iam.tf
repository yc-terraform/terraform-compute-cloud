resource "yandex_iam_service_account" "sa_instance" {
  count       = var.service_account_id == null && var.monitoring ? 1 : 0
  name        = "sa-monitoring-instance"
  description = "Service account for monitoring instance"
  folder_id   = local.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "sa_monitoring" {
  count = var.service_account_id == null && var.monitoring ? 1 : 0
  folder_id = local.folder_id
  role = "monitoring.editor"
  member = "serviceAccount:${yandex_iam_service_account.sa_instance[count.index].id}"  
}