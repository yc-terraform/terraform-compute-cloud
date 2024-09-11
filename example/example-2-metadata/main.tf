module "dev" {
  source        = "../../"
  image_family      = "ubuntu-2204-lts"
  zone          = var.yc_zone
  name          = "dev"
  hostname      = "dev"
  is_nat        = false
  description   = "dev"
  memory        = 4
  gpus          = 0
  cores         = 2
  type          = "network-ssd"
  core_fraction = 100
  serial_port_enable = true
  allow_stopping_for_update = true
  monitoring  = true
  backup      = false
  enable_oslogin_or_ssh_keys = {
    enable-oslogin = "false"  
    ssh_user        = "devops"
    ssh_key       = "~/.ssh/id_rsa.pub"
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
      
    }
  ]
  labels = {
    environment = "development"
    scope       = "dev"
  }
}
