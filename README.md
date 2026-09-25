# xx-azurerm-bootstrap-terraform-state

Reusable Terraform bootstrap building block for Azure.

This repository ships a reusable bootstrap module/block that can be published
through the pipeline and consumed by teams that need to bootstrap Terraform
state before remote state exists. It is intentionally **not** a product stack.
The consumer supplies the naming inputs and any suffix choices that fit their
own conventions.

## Contract

Creates:

- resource group
- secure StorageV2 account for Terraform state
- private blob container
- secure bootstrap Key Vault
- user-assigned managed identity for CI/CD
- GitHub OIDC federated credential
- Contributor at subscription scope
- Storage Blob Data Contributor on the state storage account
- Key Vault Administrator on the bootstrap Key Vault

The storage account disables shared access keys, enables blob versioning and
soft-delete, and expects downstream backends to use Azure AD authentication.
The Key Vault uses Azure RBAC authorization, soft-delete, purge protection, and
a default-deny firewall. Public network access remains enabled because this
bootstrap block runs before private networking exists.

## Naming Model

The module keeps naming parameterized instead of hard-coding one naming
standard. Consumers control the naming inputs such as `workload`,
`environment`, `region_code`, `instance`, `storage_account_unique_suffix`, and
`key_vault_unique_suffix` so the same bootstrap block can be reused across
different landing zones or conventions. In practice, `environment` is just a
short naming segment here; it does not force a specific lifecycle model.

## Usage

```hcl
module "bootstrap" {
  source = "git::ssh://git@github.com/jacquelinep777/xx-azurerm-bootstrap-terraform-state.git?ref=v0.0.1"

  workload    = "tfstate"
  environment = "dev"
  location    = "westeurope"
  region_code = "we"
  instance    = "01"
  biv         = "233"

  github_owner      = "xx"
  github_repository = "platform-workloads"
}
```

The example values are only placeholders. Consumers can choose their own name
segments and suffixes as long as the final names pass the provider and Azure
constraints.

Consumers use the output values to configure their downstream backend. For the
first bootstrap run, keep state local or migrate it to the created backend
after review:

```bash
terraform init
terraform plan -out=tfplan
# terraform apply only after human approval
terraform init -migrate-state
```

## Development

```bash
make fmt
make validate
make lint
make test
make policy
make scan
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.26 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.81.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_federated_identity_credential.github](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.key_vault_administrator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.state_blob_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.terraform_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account_queue_properties.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_queue_properties) | resource |
| [azurerm_storage_container.tfstate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_user_assigned_identity.terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [terraform_data.key_vault_name_validation](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.storage_account_name_validation](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_biv"></a> [biv](#input\_biv) | Security classification tag, beschikbaarheid-integriteit-vertrouwelijkheid, 1=high 2=medium 3=low. | `string` | n/a | yes |
| <a name="input_blob_delete_retention_days"></a> [blob\_delete\_retention\_days](#input\_blob\_delete\_retention\_days) | Soft-delete retention for state blobs. | `number` | `30` | no |
| <a name="input_container_delete_retention_days"></a> [container\_delete\_retention\_days](#input\_container\_delete\_retention\_days) | Soft-delete retention for state containers. | `number` | `30` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment code, for example dev, acc, or prd. | `string` | n/a | yes |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | GitHub organization or user that owns the Terraform pipeline repository. | `string` | n/a | yes |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | GitHub repository allowed to federate as the Terraform pipeline identity. | `string` | n/a | yes |
| <a name="input_instance"></a> [instance](#input\_instance) | Two digit resource instance number. | `string` | `"01"` | no |
| <a name="input_key_vault_soft_delete_retention_days"></a> [key\_vault\_soft\_delete\_retention\_days](#input\_key\_vault\_soft\_delete\_retention\_days) | n/a | `number` | `90` | no |
| <a name="input_key_vault_unique_suffix"></a> [key\_vault\_unique\_suffix](#input\_key\_vault\_unique\_suffix) | Optional lowercase alphanumeric suffix when the CAF Key Vault name is already taken. | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region name. | `string` | n/a | yes |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short region code, for example we, ne, or eus. | `string` | n/a | yes |
| <a name="input_replication_type"></a> [replication\_type](#input\_replication\_type) | Storage replication type. | `string` | `"GRS"` | no |
| <a name="input_storage_account_unique_suffix"></a> [storage\_account\_unique\_suffix](#input\_storage\_account\_unique\_suffix) | Optional lowercase alphanumeric suffix when the CAF storage account name is already taken. | `string` | `""` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Optional target subscription UUID. Defaults to the authenticated Azure context. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags. Bootstrap-owned required tags take precedence. | `map(string)` | `{}` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Optional tenant UUID. Defaults to the authenticated Azure context. | `string` | `null` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Short bootstrap workload name, for example tfstate. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_backend_config"></a> [backend\_config](#output\_backend\_config) | Backend values for downstream Terraform roots. |
| <a name="output_container_name"></a> [container\_name](#output\_container\_name) | Terraform state blob container name. |
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | Bootstrap Key Vault resource ID. |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | Bootstrap Key Vault name. |
| <a name="output_managed_identity_client_id"></a> [managed\_identity\_client\_id](#output\_managed\_identity\_client\_id) | Client ID for CI/CD OIDC authentication. |
| <a name="output_managed_identity_principal_id"></a> [managed\_identity\_principal\_id](#output\_managed\_identity\_principal\_id) | Principal ID of the Terraform pipeline managed identity. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Terraform state resource group name. |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | Terraform state storage account name. |
| <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id) | Azure subscription ID. |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | Azure tenant ID for CI/CD OIDC authentication. |
<!-- END_TF_DOCS -->
