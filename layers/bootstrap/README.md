# Bootstrap flow

This folder uses Bicep only to solve the chicken-and-egg problem for the Terraform backend.

## Ownership split

- [bootstrap.bicep](bootstrap.bicep) creates the resource group and calls [bootstrap.storage.bicep](bootstrap.storage.bicep) to create the storage account and `tfstate` container.
- Terraform takes over after that and manages the RG, storage account, container, and the rest of the bootstrap, such as CMK, private endpoint, DNS, identity wiring, and any additional backend hardening.
- [backend.tf](backend.tf) stays empty except for the `azurerm` backend block so the pipeline can inject the Bicep outputs.

## What the pipeline should do

1. Deploy [bootstrap.bicep](bootstrap.bicep) at subscription scope.
2. Resolve the backend location from Azure when the resource group already exists; only require an explicit `location` when creating a new backend.
3. Resolve a stable backend storage account name. Prefer an explicit `storageAccountName`; otherwise reuse the single existing storage account in the backend resource group; only generate a deterministic fallback name when nothing exists yet.
4. Export the same bootstrap `location` into Terraform input variables and run `terraform init -reconfigure` in the Terraform root with those backend values.
5. Import the Bicep-created RG, storage account, and container into Terraform state when they are not already tracked.
6. Apply Terraform so the remainder of the bootstrap is managed from that point onward.

## Pipeline file

- [.github/workflows/bootstrapbiceptf.yml](.github/workflows/bootstrapbiceptf.yml) contains the end-to-end flow for the Bicep seed, Terraform backend initialization, imports, and apply.
- The workflow logs in with `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, and `AZURE_SUBSCRIPTION_ID`.
- For repeatable reruns, prefer setting `storageAccountName` or secret `STATE_SA_NAME` so the backend target is explicit when a resource group contains multiple storage accounts.

## Example Azure CLI flow

```bash
az deployment sub create \
  --location westeurope \
  --template-file bootstrap.bicep \
  --parameters resourceGroupName=tfstate-rg \
               storageAccountName=sttfstate001 \
               containerName=tfstate \
               stateKey=bootstrap.tfstate

terraform init -reconfigure \
  -backend-config="resource_group_name=tfstate-rg" \
  -backend-config="storage_account_name=sttfstate001" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=bootstrap.tfstate"

export TF_VAR_location=westeurope

terraform import azurerm_resource_group.tfstate /subscriptions/<subscription-id>/resourceGroups/tfstate-rg
terraform import azurerm_storage_account.tfstate /subscriptions/<subscription-id>/resourceGroups/tfstate-rg/providers/Microsoft.Storage/storageAccounts/sttfstate001
terraform import azurerm_storage_container.tfstate /subscriptions/<subscription-id>/resourceGroups/tfstate-rg/providers/Microsoft.Storage/storageAccounts/sttfstate001/blobServices/default/containers/tfstate
```
