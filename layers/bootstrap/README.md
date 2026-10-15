# Bootstrap flow

This folder uses Bicep only to solve the chicken-and-egg problem for the Terraform backend.

## Ownership split

- [bootstrap.bicep](bootstrap.bicep) creates the resource group and calls [bootstrap.storage.bicep](bootstrap.storage.bicep) to create the storage account and `tfstate` container.
- Terraform takes over after that and manages the RG, storage account, container, and the rest of the bootstrap, such as CMK, private endpoint, DNS, identity wiring, and any additional backend hardening.
- [backend.tf](backend.tf) stays empty except for the `azurerm` backend block so the pipeline can inject the Bicep outputs.

## What the pipeline should do

1. Deploy [bootstrap.bicep](bootstrap.bicep) at subscription scope.
2. Read the deployment outputs for `resourceGroupName`, `storageAccountName`, `containerName`, and `stateKey`.
3. Run `terraform init -reconfigure` in the Terraform root with those backend values.
4. Import the Bicep-created RG, storage account, and container into Terraform state.
5. Apply Terraform so the remainder of the bootstrap is managed from that point onward.

## Pipeline file

- [.github/workflows/bootstrap.yml](.github/workflows/bootstrap.yml) contains the end-to-end flow for the Bicep seed, Terraform backend initialization, imports, and apply.
- The workflow expects a GitHub secret named `AZURE_CREDENTIALS` for Azure login.

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

terraform import azurerm_resource_group.tfstate /subscriptions/<subscription-id>/resourceGroups/tfstate-rg
terraform import azurerm_storage_account.tfstate /subscriptions/<subscription-id>/resourceGroups/tfstate-rg/providers/Microsoft.Storage/storageAccounts/sttfstate001
terraform import azurerm_storage_container.tfstate /subscriptions/<subscription-id>/resourceGroups/tfstate-rg/providers/Microsoft.Storage/storageAccounts/sttfstate001/blobServices/default/containers/tfstate
```
