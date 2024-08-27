# instance_by_tpl

This submodule create a `google_compute_instance_template` resource, specified total count instances by recent tpl will create `google_compute_instance_from_template` resource, last create an instance group by `google_compute_instance_group` resource to manager instances.

## Usage
module "xxx" {
  source	= source = "git@Albertwzp/terraform-modules.git//instance_by_tpl"
  ...
}

## Inputs

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| image_name | string | debian-10-buster-v20211209 | yes | Image you will build intance |
| tpl_name | string | sample-tpl | yes | |
| machine_type | e2-micro | yes | That's machine what you think |
| disk_type | pd-ssd | yes | That's disk what you think |
| boot_disk_size | number | 100 | yes | The boot disk size, unit GB |
| add_disk_size | number | 100 | yes | The additional disk size, unit GB |
| add_disk_num | number | 0 | yes | The count additional disk, unit GB |
| sa_email | sting |  | no | binding seriveaccount when build instance |
| is_public | bool | false | no | if binding external a public ip |
| subnetwork | sting |  | no | binding subnet when build instance |
| subnetwork_project | sting |  | no | binding subnet's project when build instance |
| tags | list(sting) | [] | no | Tags when build instance |
| labels | map(sting) | {} | no | Labels when build instance |
| | | | | |
| total | number | 1 | yes | how many instance you will build |
| instance_prefix | string | player | yes | |
| project | string |  | yes | assign project id |
| | | | | |
| zone | string | us-central1-a | yes | Build instance in specified zone if not set it random zone |
| group_name | string | sample | yes | |

## Outputs

| Name | Description |
|------|-------------|
| tpl_id | Id of template created|
| group_id | Id of Group when created |
| instance_ip | Ip of created instance |
