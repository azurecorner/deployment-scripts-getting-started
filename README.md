# deployment-scripts-getting-started
# https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/azure-resource-manager/bicep/deployment-script-develop.md
$templateFile='main.bicep' 
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