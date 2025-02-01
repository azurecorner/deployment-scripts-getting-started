@description('Specify the resource location.')
param location string = resourceGroup().location

//https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-script-develop?tabs=CLI#use-an-existing-storage-account
@maxLength(10) 
param namePrefix string ='datasync'
param name string = 'John Dole'

param storageAccountName string = '${namePrefix}stg${uniqueString(resourceGroup().id)}'

param deploymentScriptName string = '${namePrefix}ds'


resource storageAccount 'Microsoft.Storage/storageAccounts@2023-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'

  
  properties: {
    accessTier: 'Hot'
    publicNetworkAccess: 'Enabled'
    
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
      
    }
  }
}
resource privateDeploymentScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: deploymentScriptName

  location: location
  kind: 'AzurePowerShell'

  properties: {
    storageAccountSettings: {
      storageAccountName: storageAccount.name
      storageAccountKey: listKeys(resourceId('Microsoft.Storage/storageAccounts', storageAccountName), '2023-01-01').keys[0].value
    }

    azPowerShellVersion: '10.0'
    arguments: '-name ${name}'
  
    // scriptContent: 'Write-Host "Hello World!"'
    scriptContent: loadTextContent('scripts/hello.ps1')
      retentionInterval: 'P1D'
  }
}

output storageAccountName string = storageAccount.name
