variable "name" {
  description = "Resource name."
  type        = string
}

variable "platform_id" {
  description = "The type of virtual machine to create. The default is 'standard-v1'."
  type        = string
  default     = "standard-v1"
}

variable "zone" {
  description = "The availability zone where the virtual machine will be created. If it is not provided, the default provider folder is used."
  type        = string
}

variable "description" {
  description = "Description of the instance."
  type        = string
  default     = ""
}

variable "memory" {
  description = "Memory size"
  type        = number
  default     = 4
}

variable "gpus" {
  description = "Number of GPUs"
  type        = number
  default     = 0
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "core_fraction" {
  description = "CPU core fraction"
  type        = number
  default     = 100
}

variable "hostname" {
  description = "Host name for the instance. This field is used to generate the instance fqdn value. The host name must be unique within the network and region. If not specified, the host name will be equal to id of the instance and fqdn will be <id>.auto.internal. Otherwise FQDN will be <hostname>.<region_id>.internal."
  type        = string
  default     = ""
}

variable "size" {
  description = "The size of the disk in GB."
  type        = number
  default     = 100
  validation {
    condition     = var.size >= 4 && var.size <= 8192
    error_message = "Disk size must be in range [4, 8192] GB."
  }
}
variable "network_interfaces" {
  description = "List of network interfaces"
  type = list(object({
    subnet_id          = string
    index              = optional(number)
    ipv4               = optional(bool, true)
    ip_address         = optional(string)
    nat                = optional(bool, false)
    nat_ip_address     = optional(string)
    security_group_ids = optional(list(string))
    dns_record = optional(list(object({
      fqdn        = string
      dns_zone_id = optional(string)
      ttl         = optional(number)
      ptr         = optional(bool, false)
    })), [])
  }))
  default = [
    {
      subnet_id          = null
      index              = null
      ipv4               = true
      ip_address         = null
      nat                = false
      nat_ip_address     = null
      security_group_ids = null
      dns_record = []
    }
  ]
}


variable "block_size" {
  description = "Block size of the disk, specified in bytes"
  type        = number
  default     = 4096

  validation {
    condition     = contains([4096, 8192, 16384, 32768, 65536, 131072], var.block_size)
    error_message = "Block size must be one of 4096, 8192, 16384, 32768, 65536, 131072."
  }
}
variable "type" {
  description = "Type of disk to create."
  type        = string
  validation {
    condition     = contains(["network-hdd", "network-ssd", "network-ssd-nonreplicated", "network-ssd-io-m3"], var.type)
    error_message = "The type must be one of: network-hdd, network-ssd, network-ssd-io-m3, network-ssd-nonreplicated."
  }
}

variable "image_id" {
  description = "The source image to use for disk creation"
  type        = string
  default     = null
}

variable "image_family" {
  description = "The source image family to use for disk creation. command: yc compute image list --folder-id standard-images"
  type        = string
  default     = null
}

variable "snapshot_id" {
  description = "The source snapshot to use for disk creation"
  type        = string
  default     = null
}

variable "disk_placement_policy" {
  description = "Disk placement policy configuration"
  type = object({
    disk_placement_group_id = string
  })
  default = null
}

variable "folder_id" {
  description = "The ID of the folder that the resource belongs to. If it is not provided, the default provider folder is used."
  type        = string
  default     = ""
}

variable "boot_disk_auto_delete" {
  description = "Defines whether the disk will be auto-deleted when the instance is deleted. The default value is true."
  type        = bool
  default     = true
}

variable "boot_disk_device_name" {
  description = "The device name of the boot disk."
  type        = string
  default     = null
}

variable "boot_disk_mode" {
  description = "Type of access to the disk resource. By default, a disk is attached in READ_WRITE mode."
  type        = string
  default     = "READ_WRITE"
}

variable "boot_disk_disk_id" {
  description = "The ID of the boot disk."
  type        = string
  default     = null
}

variable "boot_disk_name" {
  description = "The name of the boot disk."
  type        = string
  default     = null
}

variable "boot_disk_description" {
  description = "The description of the boot disk."
  type        = string
  default     = null
}

variable "boot_disk_size" {
  description = "The size of the boot disk."
  type        = number
  default     = 10
}

variable "boot_disk_block_size" {
  description = "The block size of the boot disk."
  type        = number
  default     = 4096
}

variable "boot_disk_type" {
  description = "The type of the boot disk."
  type        = string
  default     = "network-ssd"
}

variable "boot_disk_image_id" {
  description = "The image ID of the boot disk."
  type        = string
  default     = null
}

variable "boot_disk_snapshot_id" {
  description = "The snapshot ID of the boot disk."
  type        = string
  default     = null
}

variable "labels" {
  description = "A set of key/value label pairs to assign to the instance."
  type        = map(string)
  default     = {}
}

variable "metadata" {
  description = "Metadata key/value pairs to make available from within the instance."
  type        = map(string)
  default     = {}
}

variable "metadata_options" {
  description = "Metadata options for the instance"
  type = object({
    http_endpoint = string
    http_tokens   = string
  })
  default = {
    http_endpoint = "disabled"
    http_tokens   = "optional"
  }
}

variable "allow_stopping_for_update" {
  description = "If true, allows Terraform to stop the instance in order to update its properties. If you try to update a property that requires stopping the instance without setting this field, the update will fail."
  type        = bool
  default     = false
}

variable "network_acceleration_type" {
  description = "Type of network acceleration. The default is standard. Values: standard, software_accelerated."
  type        = string
  default     = "standard"
}

variable "gpu_cluster_id" {
  description = "ID of the GPU cluster to attach this instance to. The GPU cluster must exist in the same zone as the instance."
  type        = string
  default     = ""
}

variable "maintenance_policy" {
  description = "Behaviour on maintenance events. The default is unspecified. Values: unspecified, migrate, restart."
  type        = string
  default     = "unspecified"
}

variable "maintenance_grace_period" {
  description = "Time between notification via metadata service and maintenance. E.g., 60s."
  type        = string
  default     = ""
}


variable "network_interface_index" {
  description = "Index of network interface, will be calculated automatically for instance create or update operations if not specified. Required for attach/detach operations."
  type        = number
  default     = 0
}

variable "network_interface_ipv4" {
  description = "Allocate an IPv4 address for the interface. The default value is true."
  type        = bool
  default     = true
}

variable "network_interface_ip_address" {
  description = "The private IP address to assign to the instance. If empty, the address will be automatically assigned from the specified subnet."
  type        = string
  default     = ""
}

variable "network_interface_ipv6" {
  description = "If true, allocate an IPv6 address for the interface. The address will be automatically assigned from the specified subnet."
  type        = bool
  default     = false
}

variable "network_interface_ipv6_address" {
  description = "The private IPv6 address to assign to the instance."
  type        = string
  default     = ""
}

variable "network_interface_nat" {
  description = "Provide a public address, for instance, to access the internet over NAT."
  type        = bool
  default     = false
}

variable "network_interface_nat_ip_address" {
  description = "Provide a public address, for instance, to access the internet over NAT. Address should be already reserved in web UI."
  type        = string
  default     = ""
}

variable "network_interface_security_group_ids" {
  description = "Security group ids for network interface."
  type        = list(string)
  default     = []
}

variable "network_interface_dns_record_fqdn" {
  description = "DNS record FQDN (must have a dot at the end)."
  type        = string
  default     = ""
}

variable "network_interface_dns_record_dns_zone_id" {
  description = "DNS zone ID (if not set, private zone used)."
  type        = string
  default     = ""
}

variable "network_interface_dns_record_ttl" {
  description = "DNS record TTL in seconds."
  type        = number
  default     = 300
}

variable "network_interface_dns_record_ptr" {
  description = "When set to true, also create a PTR DNS record."
  type        = bool
  default     = false
}

variable "network_interface_ipv6_dns_record_fqdn" {
  description = "DNS record FQDN (must have a dot at the end)."
  type        = string
  default     = ""
}

variable "network_interface_ipv6_dns_record_dns_zone_id" {
  description = "DNS zone ID (if not set, private zone used)."
  type        = string
  default     = ""
}

variable "network_interface_ipv6_dns_record_ttl" {
  description = "DNS record TTL in seconds."
  type        = number
  default     = 300
}

variable "network_interface_ipv6_dns_record_ptr" {
  description = "When set to true, also create a PTR DNS record."
  type        = bool
  default     = false
}
variable "is_nat" {
  description = "Whether to enable NAT for the instance."
  type        = bool
  default     = false
}
variable "network_interface_nat_dns_record_fqdn" {
  description = "DNS record FQDN (must have a dot at the end)."
  type        = string
  default     = ""
}

variable "network_interface_nat_dns_record_dns_zone_id" {
  description = "DNS zone ID (if not set, private zone used)."
  type        = string
  default     = ""
}

variable "network_interface_nat_dns_record_ttl" {
  description = "DNS record TTL in seconds."
  type        = number
  default     = 300
}

variable "network_interface_nat_dns_record_ptr" {
  description = "When set to true, also create a PTR DNS record."
  type        = bool
  default     = false
}

variable "secondary_disks" {
  description = "A set of disks to attach to the instance."
  type        = list(object({
    disk_id     = string
    auto_delete = bool
    device_name = string
    mode        = string
  }))
  default     = []
}

variable "scheduling_policy_preemptible" {
  description = "Specifies if the instance is preemptible. Defaults to false."
  type        = bool
  default     = false
}

variable "placement_policy" {
  description = "Placement policy configuration"
  type = object({
    placement_group_id = string
    host_affinity_rules = list(object({
      key    = string
      op     = string
      values = list(string)
    }))
  })
  default = {
    placement_group_id = null
    host_affinity_rules = []
  }
}

variable "local_disks" {
  description = "List of local disks that are attached to the instance."
  type        = list(object({
    size_bytes = number
  }))
  default     = []
}

variable "filesystems" {
  description = "List of filesystems that are attached to the instance."
  type        = list(object({
    filesystem_id = string
    device_name   = string
    mode          = string
  }))
  default     = []
}

variable "service_account_id" {
  description = "ID of the service account authorized for this instance."
  type        = string
  default     = ""
}
