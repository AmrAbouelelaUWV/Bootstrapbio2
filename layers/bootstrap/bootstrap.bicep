targetScope = 'subscription'

@description('Name of the resource group that will hold the Terraform state storage.')
param resourceGroupName string

@description('Azure region for the resource group and storage account.')
param location string = deployment().location

@description('Globally unique name of the storage account that will host Terraform state.')
param storageAccountName string

@description('Blob container name used for Terraform state files.')
param containerName string = 'tfstate'

@description('Optional tags applied to the bootstrap resources.')
param tags object = {}

@description('Default blob key to use for the Terraform state file.')
param stateKey string = 'terraform.tfstate'

resource stateResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

module storageBootstrap './bootstrap.storage.bicep' = {
  name: 'storageBootstrap'
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    stateResourceGroup
  ]
  params: {
    storageAccountName: storageAccountName
    containerName: containerName
    tags: tags
    location: location
  }
}

output resourceGroupName string = stateResourceGroup.name
output storageAccountName string = storageBootstrap.outputs.storageAccountName
output storageAccountId string = storageBootstrap.outputs.storageAccountId
output containerName string = storageBootstrap.outputs.containerName
output stateKey string = stateKey
