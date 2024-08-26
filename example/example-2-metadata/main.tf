module "dev" {
  source        = "../../"
  image_family      = "ubuntu-2004-lts"
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
  backup      = true
  enable_oslogin_or_ssh_keys = {
    enable-oslogin = "false"
    ssh-keys = "devops:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3U4K+k01JcsTvZNa7n1MlJ0TkEVY+7+gfsy+GczGYyXRVpekSydQZB3S/spsb6MW9da94uC2iUwtN/UHYVgiCOU51d7e/1LS4riBsz4NKT4kkWBZxXhmfFAxS4cz1WCPfklF5dePPjyE997jH2tCFStiWlEn7gML1R96/QPLmqRebjdRqPDgTZE4YuIOTsfWiZtoQTPaVg64s/wjU0K0UPFulPYlIvUzt8ZaZ+/mfvJO32tNkqLzN/9uMtFZI+r1dEV/cQyx7C+5S9ysiuiYzXXeoLPGvq4PF2MtcUhDq1LgUI7GP9LYMFuXLamqE3zmdlk1acJro1ViBWRtnADej devops@devops"
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
