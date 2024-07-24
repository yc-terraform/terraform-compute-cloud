
module "dev" {
  source       = "../"
  image_family = "ubuntu-2404-lts-oslogin"
  subnet_id    = "e9b1rvg1c0vpio65eks8"
  zone         = var.yc_zone
  name         = "dev"
  hostname     = "dev"
  is_nat       = true
  description  = "dev"
  cores        = 2
  memory       = 4
  core_fraction = 100
  labels = {
    environment = "development"
    scope       = "dev"
  }
}
