Connect-AzAccount
Get-AzContext

Get-AzSubscription -SubscriptionName 'IndustryExperiencesInternal' | Set-AzContext -Name 'IndExp'

Get-AzStorageAccount | ?{$_.StorageAccountName -like "erc*"}


$resourceGroupName = "ErcSandboxEast2"
$storageAccountName = "ercmscentralstore"
$fileShareName = "ecfiles1"

# Use the sample at https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-use-files-windows#mount-the-azure-file-share-with-powershell as strating point
$storageAccount = Get-AzStorageAccount -Name $storageAccountName -ResourceGroupName $resourceGroupName
$storageAccountKeys = Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageAccountName

$fileShare = Get-AzStorageShare -Context $storageAccount.Context | Where-Object { 
    $_.Name -eq $fileShareName -and $_.IsSnapshot -eq $false
}

if ($fileShare -eq $null) {
    throw [System.Exception]::new("Azure file share not found")
}

# The value given to the root parameter of the New-PSDrive cmdlet is the host address for the storage account, 
# <storage-account>.file.core.windows.net for Azure Public Regions. $fileShare.StorageUri.PrimaryUri.Host is 
# used because non-Public Azure regions, such as sovereign clouds or Azure Stack deployments, will have different 
# hosts for Azure file shares (and other storage resources).

# Now save the password in the encrypted location
$password = ConvertTo-SecureString -String $storageAccountKeys[0].Value -AsPlainText -Force

$accountName = "AZURE\$($storageAccount.StorageAccountName)"



