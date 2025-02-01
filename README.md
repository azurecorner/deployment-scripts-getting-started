# deployment-scripts-getting-started
# run script in azure using deployment scripts and bicep
1. Overview
Azure Deployment Scripts allow you to run PowerShell or Bash scripts during a Bicep deployment. This is useful for tasks like configuring resources, retrieving values, or executing custom logic.
https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-script-bicep?tabs=CLI


The deployment script service requires  a storage account and a container instance. 
 the storage account and a container instance cleans up after the deployment script finishes


the minimum permissions
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
      ],
    }
  ],
  "assignableScopes": [
    "[subscription().id]"
  ]
}
This custom role, named "Deployment Script Minimum Privilege for Deployment Principal," is designed to grant the least privilege necessary for executing deployment scripts in Azure. It ensures that the deployment principal has sufficient permissions to manage storage accounts, container instances, resource deployments, and deployment scripts.

The role includes permissions to perform all actions (*) on the following resource types:

Storage Accounts (Microsoft.Storage/storageAccounts/*) – Grants full control over storage accounts.
Container Groups (Microsoft.ContainerInstance/containerGroups/*) – Allows full management of container instances.
Resource Deployments (Microsoft.Resources/deployments/*) – Provides complete control over resource deployment operations.
Deployment Scripts (Microsoft.Resources/deploymentScripts/*) – Enables full access to Azure Deployment Scripts.
This custom role is assignable at the subscription level, meaning it applies to all resources within the specified Azure subscription. The goal of this role is to provide just enough access for the deployment principal to execute and manage deployment scripts while maintaining security and operational control.

Use an existing storage account =>
For the script to run and allow for troubleshooting, you need a storage account and a container instance. You can either designate an existing storage account or let the script service create both the storage account and the container instance automatically.

Configure a container instance
A deployment script requires a new Azure container instance. You can't specify an existing container instance. However, you can customize the container's group name by using containerGroupName. If you don't specify a group name, it's automatically generated.


# https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/azure-resource-manager/bicep/deployment-script-develop.md
$templateFile='inline-script.bicep' 
$resourceGroupName='RG-DEPLOYMENT-SCRIPT-GETTING-STARTED'
 $deploymentName='deployment-$resourceGroupName'
  az group create -l westus -n $resourceGroupName 
  New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFile -DeploymentDebugLogLevel All 

$containerName='acilinuxprivateipcontainergroup'

az container logs --resource-group $resourceGroupName --name $containerName

az container attach --resource-group $resourceGroupName --name $containerName

az container show --resource-group $resourceGroupName --name $containerName

# loading file
$templateFile='load-text-content.bicep' 
$resourceGroupName='RG-DEPLOYMENT-SCRIPT-GETTING-STARTED'
 $deploymentName='deployment-$resourceGroupName'
  az group create -l westus -n $resourceGroupName 
  New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFile -DeploymentDebugLogLevel All 

# use storage account

  $templateFile='use-storage-account.bicep' 
$resourceGroupName='RG-DEPLOYMENT-SCRIPT-GETTING-STARTED'
 $deploymentName='deployment-$resourceGroupName'
  az group create -l westus -n $resourceGroupName 
  New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFile -DeploymentDebugLogLevel All 


  # use storage account and container group

  $templateFile='use-storage-account-container-group.bicep' 
$resourceGroupName='RG-DEPLOYMENT-SCRIPT-GETTING-STARTED'
 $deploymentName='deployment-$resourceGroupName'
  az group create -l westus -n $resourceGroupName 
  New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFile -DeploymentDebugLogLevel All 