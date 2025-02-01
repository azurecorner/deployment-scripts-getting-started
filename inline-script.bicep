// Inline script example
param deploymentScriptName string = 'inlinePS'
param location string = resourceGroup().location

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: deploymentScriptName
  location: location
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: '10.0'
    
    scriptContent: '''
      Write-Host 'Hello World'
      $output = 'Hello world from inline script'
      $DeploymentScriptOutputs = @{}
      $DeploymentScriptOutputs['text'] = $output
    '''
    retentionInterval: 'PT1H'
  }
}

output result string = deploymentScript.properties.outputs.text
