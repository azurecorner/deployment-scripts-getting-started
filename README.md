# deployment-scripts-getting-started

$templateFile='main.bicep' 
$resourceGroupName='RG-DEPLOYMENT-SCRIPT-GETTING-STARTED'
 $deploymentName='deployment-$resourceGroupName'
  az group create -l westus -n $resourceGroupName 
  New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFile -DeploymentDebugLogLevel All 

$containerName='acilinuxprivateipcontainergroup'

az container logs --resource-group $resourceGroupName --name $containerName

az container attach --resource-group $resourceGroupName --name $containerName

az container show --resource-group $resourceGroupName --name $containerName


$templateFile='load-text-content.bicep' 
$resourceGroupName='RG-DEPLOYMENT-SCRIPT-GETTING-STARTED'
 $deploymentName='deployment-$resourceGroupName'
  az group create -l westus -n $resourceGroupName 
  New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFile -DeploymentDebugLogLevel All 