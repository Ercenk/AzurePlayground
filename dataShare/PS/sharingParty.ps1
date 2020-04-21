# Set variables with your own values
$subscriptionName = "IndustryExperiencesInternal"
$resourceGroupName = "ErcSandbox2"
$location = "set it below"


$dataShareAccountName = "ercdatasharesample"
$dataShareName = "MyDataShare"

$blobDatasetName = "media"
$storageAccountName = "ercsandboxeast2"
$blobContainer = "media"
$storageAccountResourceId = "<Storage account resource id>"


# Login Az subscription
Connect-AzAccount

# Select the appropriate subscription
$subscription = Get-AzSubscription -SubscriptionName $subscriptionName
Set-AzContext $subscription

# Create the resource group if it is not already there
$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -Locatio

# Create a new Azure Data Share account
################################################

# To remove
# Remove-AzDataShareAccount -Name .... -ResourceGroupName .....

# The Data Share feature is not available in all regions, query where it is available

(Get-AzResourceProvider -ProviderNamespace Microsoft.DataShare | Where-Object {$_.ResourceTypes.ResourceTypeName -eq "accounts"}).Locations

$location = "eastus2"

New-AzDataShareAccount -ResourceGroupName $resourceGroupName -Name $dataShareAccountName -Location $location


# Create the data share
###########################

New-AzDataShare -ResourceGroupName $resourceGroupName -AccountName $dataShareAccountName -Name $dataShareName


#Add a blob dataset to the datashare
$storageAccount = Get-AzStorageAccount | ?{$_.StorageAccountName -eq $storageAccountName} 

if ($null -eq $storageAccount) {
    New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -SkuName Standard_LRS -Location $location
    $storageAccount = Get-AzStorageAccount | ?{$_.StorageAccountName -eq $storageAccountName} 
}

$storageAccountResourceId = $storageAccount.Id

New-AzDataShareDataSet -ResourceGroupName $resourceGroupName -AccountName $dataShareAccountName -ShareName $dataShareName -Name $blobDataSetName -StorageAccountResourceId $storageAccountResourceId -Container $blobContainer

