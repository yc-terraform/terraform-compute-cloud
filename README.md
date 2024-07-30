# Compute Instance Terraform Module for Yandex.Cloud

## Features

- Create and manage compute instances in Yandex.Cloud
- Supports various configurations including disk, network, and scheduling options
- Allows specification of resource allocation, boot disks, and network interfaces

## How to Configure Terraform for Yandex.Cloud

1. Install [YC CLI](https://cloud.yandex.com/docs/cli/quickstart)
2. Add environment variables for Terraform authentication in Yandex.Cloud

    ```bash
    export YC_TOKEN=$(yc iam create-token)
    export YC_CLOUD_ID=$(yc config get cloud-id)
    export YC_FOLDER_ID=$(yc config get folder-id)
    ```

## Requirements

| Name       | Version |
|------------|---------|
| terraform  | >= 1.0.0 |
| yandex     | >= 0.101.0 |

## Providers

| Name   | Version |
|--------|---------|
| yandex | 0.122.0 |

## Resources

| Name                           | Type    |
|--------------------------------|---------|
| yandex_compute_instance.this   | resource |

## Inputs

| Name                      | Description                                                                                  | Type                      | Default | Required |
|---------------------------|----------------------------------------------------------------------------------------------|---------------------------|---------|:--------:|
| resources                 | Compute resources that are allocated for the instance. The structure is documented below.   | `object`                  | n/a     | yes      |
| boot_disk                 | The boot disk for the instance. The structure is documented below.                           | `object`                  | n/a     | yes      |
| network_interface         | Networks to attach to the instance. This can be specified multiple times.                    | `list(object)`            | n/a     | yes      |
| name                      | Resource name.                                                                              | `string`                  | null    | no       |
| description               | Description of the instance.                                                                  | `string`                  | null    | no       |
| folder_id                 | The ID of the folder that the resource belongs to. If not provided, the default provider folder is used. | `string`                  | null    | no       |
| labels                    | A set of key/value label pairs to assign to the instance.                                    | `map(string)`             | {}      | no       |
| zone                      | The availability zone where the virtual machine will be created.                             | `string`                  | null    | no       |
| hostname                  | Host name for the instance. This field is used to generate the instance FQDN value.           | `string`                  | null    | no       |
| metadata                  | Metadata key/value pairs to make available from within the instance.                         | `map(string)`             | {}      | no       |
| platform_id               | The type of virtual machine to create. The default is 'standard-v1'.                          | `string`                  | "standard-v1" | no    |
| secondary_disk            | A set of disks to attach to the instance. The structure is documented below.                  | `list(object)`            | []      | no       |
| scheduling_policy         | Scheduling policy configuration. The structure is documented below.                         | `object`                  | {}      | no       |
| placement_policy          | The placement policy configuration. The structure is documented below.                      | `object`                  | {}      | no       |
| service_account_id        | ID of the service account authorized for this instance.                                      | `string`                  | null    | no       |
| allow_stopping_for_update | If true, allows Terraform to stop the instance in order to update its properties.              | `bool`                    | false   | no       |
| network_acceleration_type | Type of network acceleration. The default is standard.                                        | `string`                  | "standard" | no    |
| local_disk                | List of local disks that are attached to the instance. The structure is documented below.    | `list(object)`            | []      | no       |
| filesystem                | List of filesystems that are attached to the instance. The structure is documented below.   | `list(object)`            | []      | no       |

## Outputs

| Name                         | Description                                          |
|------------------------------|------------------------------------------------------|
| fqdn                         | The fully qualified DNS name of this instance.      |
| network_interface.0.ip_address | The internal IP address of the instance.         |
| network_interface.0.nat_ip_address | The external IP address of the instance.        |