# Run Script in Azure Using Deployment Scripts and Bicep

## 1. Overview
Azure Deployment Scripts allow you to run PowerShell or Bash scripts during a Bicep deployment. This is useful for tasks like configuring resources, retrieving values, or executing custom logic.  
[Learn more about Deployment Scripts in Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-script-bicep?tabs=CLI)

The deployment script service requires both a **storage account** and a **container instance**.  
Once the deployment script finishes executing, the storage account and container instance **automatically clean up** to ensure efficient resource management.

---

## 2. Minimum Permissions Required  

To execute deployment scripts, the deployment service principal (or user) must have the necessary permissions.
Below is a **custom role definition** that grants the least privilege required.

### **Custom Role: Deployment Script Minimum Privilege for Deployment Principal**
```json
{
  "roleName": "deployment-script-minimum-privilege-for-deployment-principal",
  "description": "Configure least privilege for the deployment principal in deployment script",
  "type": "customRole",
  "IsCustom": true,
  "permissions": [
    {
      "actions": [
        "Microsoft.Storage/storageAccounts/*",
        "Microsoft.ContainerInstance/containerGroups/*",
        "Microsoft.Resources/deployments/*",
        "Microsoft.Resources/deploymentScripts/*"
      ]
    }
  ],
  "assignableScopes": [
    "[subscription().id]"
  ]
}
```
### **Description of Role Permissions**  

This custom role ensures that the deployment service principal (or user) has only the necessary permissions to manage resources required for deployment scripts.  

- **Storage Accounts (`Microsoft.Storage/storageAccounts/*`)** – Full control over storage accounts.  
- **Container Groups (`Microsoft.ContainerInstance/containerGroups/*`)** – Enables complete management of container instances.  
- **Resource Deployments (`Microsoft.Resources/deployments/*`)** – Allows full control over Azure resource deployments.  
- **Deployment Scripts (`Microsoft.Resources/deploymentScripts/*`)** – Grants full access to deployment scripts in Azure.  

This role is **assignable at the subscription level**, meaning it applies to all resources within the specified Azure subscription. The goal is to provide just enough access for script execution while ensuring security and operational control.  

---

## 3. Use an Existing Storage Account  

To run a deployment script and allow for troubleshooting, you need both a **storage account** and a **container instance**. You have two options:  

1. **Use an existing storage account** – Specify an existing storage account in the script configuration.  
2. **Let the script service create both** – If no storage account is specified, the deployment script service will automatically create both the storage account and the container instance.  

---

## 4. Configure a Container Instance  

A deployment script requires a **new Azure Container Instance**. You **cannot** use an existing container instance. However, you can customize the container group name using the `containerGroupName` parameter.  

- **If you specify a group name**, it will be used as the container group name.  
- **If you don’t specify a name**, Azure will automatically generate one.  

This setup ensures that each deployment script runs in an isolated and controlled environment.  

## 4. Inline Script Example in Bicep

### 1. Overview  

This example demonstrates how to use an **inline Azure PowerShell script** within a **Bicep deployment script**. The script runs during deployment and outputs a simple message.

---

### 2. Bicep Code   

```bicep

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
```

### Explanation of Each Component  

#### 1. Parameters  
- **`deploymentScriptName`** – Specifies the name of the deployment script (`inlinePS`).  
- **`location`** – Uses the resource group’s location to deploy the script.  

---

#### 2. Deployment Script Resource  
This defines a **`Microsoft.Resources/deploymentScripts`** resource that executes an **Azure PowerShell script**.  

- **`kind: 'AzurePowerShell'`** – Specifies that the script will run using Azure PowerShell.  
- **`azPowerShellVersion: '10.0'`** – Sets the PowerShell version to **10.0**.  
- **`scriptContent`** – Contains the actual PowerShell script:  
  - **`Write-Host 'Hello World'`** – Prints `"Hello World"` to the console.  
  - **Creates a dictionary (`$DeploymentScriptOutputs`)** to store output values.  
  - **Stores the text `"Hello world from inline script"`** as an output.  

---

#### 3. Retention Interval  
- **`retentionInterval: 'PT1H'`** – Keeps the script execution logs for **1 hour** before automatic cleanup.  

---

#### 4. Output Variable  
The script outputs the `text` value, which is retrieved using:  

```bicep
output result string = deploymentScript.properties.outputs.text
```

### Deploying an Inline Script Using Bicep  


This example demonstrates how to deploy an **inline Bicep script** using **Azure CLI** and **PowerShell**. The script creates a resource group and deploys the Bicep template within it.  

---

### Deployment Commands  

```powershell
$templateFile = 'inline-script.bicep' 
$resourceGroupName = 'RG-DEPLOYMENT-SCRIPT-GETTING-STARTED'
$deploymentName = 'deployment-$resourceGroupName'

# Create a resource group
az group create -l westus -n $resourceGroupName 

# Deploy the Bicep template
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFile -DeploymentDebugLogLevel All  
```

## 5. Monitoring

During the deployment of the deployment script, we can observe the following resources listed in the resource group:

A storage account
A container instance
The deployment script


![test1](https://github.com/user-attachments/assets/5aaa5490-a148-4c9f-b039-898e895f38d9)

Additionally, we can also view the deployment script logs.

![test2](https://github.com/user-attachments/assets/50013ad5-4882-49fa-a654-5ab82b42fafb)

