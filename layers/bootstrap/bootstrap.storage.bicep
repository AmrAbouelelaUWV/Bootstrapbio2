targetScope = 'resourceGroup'

@description('Globally unique name of the storage account that will host Terraform state.')
param storageAccountName string

@description('Blob container name used for Terraform state files.')
param containerName string = 'tfstate'

@description('Optional tags applied to the bootstrap resources.')
param tags object = {}

@description('Azure region for the storage account.')
param location string = resourceGroup().location

resource stateStorageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  tags: tags
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    publicNetworkAccess: 'Enabled'
    supportsHttpsTrafficOnly: true
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  name: 'default'
  parent: stateStorageAccount
}

resource stateContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = {
  name: containerName
  parent: blobService
  properties: {
    publicAccess: 'None'
  }
}

output storageAccountName string = stateStorageAccount.name
output storageAccountId string = stateStorageAccount.id
output containerName string = stateContainer.name
