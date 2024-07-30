terraform {
  required_version = ">= 0.13"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "> 0.8"
    }
  }
}
provider "yandex" {
  zone = "ru-central1"
}