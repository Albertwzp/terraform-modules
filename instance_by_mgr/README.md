# instance_from_mgr

This submodule create a `google_compute_instance_template` resource, then create `google_compute_instance_group_manager` resource to create an instance group and specified total number instance, last we relate a health-check about ssh port by `google_compute_health_check` resource.

## Usage
module "xxx" {
  source	= source = "git@Albertwzp/terraform-modules.git//instance_by_mgr"
  ...
}

## Inputs

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| image_project | string | debian-cloud | yes | Public image project |
| image_family | string | debian-11 | yes | Image Family you will build |
| | | | | |
| tpl_name | string | sample-tpl | yes | template name prefix |
| machine_type | e2-micro | yes | That's what you think |
| boot_disk | number | 100 | yes | The boot disk size, unit GB |
| tags | list(sting) | [] | no | Tags when build instance |
| labels | map(sting) | {} | no | Labels when build instance |
| | | | | |
| mgr_name | string | instance-mgr | yes | instance_group_manager name |
| total | number | 1 | yes | how many instance you will build |
| instance_prefix | string | player | yes | |
| project | string |  | yes | assign project id |
| zone | string | us-central1-a | yes | Build instance in specified zone |

## Outputs

| Name | Description |
|------|-------------|
| tpl_id | Id of template created|
| group_id | Id of Group create by mgr |
| instance_group_manager_id | group mgr id|
