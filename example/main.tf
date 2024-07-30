module "dev" {
  source        = "../"
  image_family  = "ubuntu-2404-lts-oslogin"
  zone          = var.yc_zone
  name          = "dev"
  hostname      = "dev"
  is_nat        = false
  description   = "dev"
  memory        = 8
  gpus          = 0 
  cores         = 4
  type          = "network-ssd"
  core_fraction = 100

  network_interfaces = [
    {
      subnet_id = "e9b1rvg1c0vpio65eks8"
    },
    {
      subnet_id = "e9b1rvg1c0vpio65eks8"
      ipv4      = true
      nat       = false
      dns_record = []
    }
  ]
  labels = {
    environment = "development"
    scope       = "dev"
  }
}
