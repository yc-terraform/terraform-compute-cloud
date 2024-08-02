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
  serial_port_enable = true
  enable_oslogin_or_ssh_keys = {
    enable-oslogin = "true"
    ssh-keys       = null
  }
  metadata_options = {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  network_interfaces = [
    {
      subnet_id = "e9b1rvg1c0vpio65eks8"
      ipv4       = true
      nat        = true
      
    },
    {
      subnet_id  = "e9b1rvg1c0vpio65eks8"
      ipv4       = true
      nat        = false
      dns_record = []
    }
  ]
  labels = {
    environment = "development"
    scope       = "dev"
  }
  static_ip = {
    name = "my-static-ip"
    description = "Static IP for dev instance"
    external_ipv4_address = {
      zone_id = var.yc_zone
    }
  }
  monitoring = true
}
