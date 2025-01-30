param name string = 'John Dole'
param location string = resourceGroup().location

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'loadTextContentPS'
  location: location
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: '10.0'
    arguments: '-name ${name}'
    scriptContent: loadTextContent('scripts/hello.ps1')
    retentionInterval: 'P1D'
  }
}
