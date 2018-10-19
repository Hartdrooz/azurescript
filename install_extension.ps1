$resourceGroup="hopixtraining"
$vmName="hopixwindows"
$storageName="hopixtrainingstorage"
$createStorage=$false
$location="canadaeast"

if ($createStorage)
{
  "Creating AzureStorage"

  New-AzureRmStorageAccount -ResourceGroupName $resourceGroup `
    -Location $location `
    -Name $storageName `
    -SkuName Standard_LRS                     
}

"Publishing script in Storage"

Publish-AzureRmVMDscConfiguration -ConfigurationPath .\iisconf.ps1 `
      -ResourceGroupName $resourceGroup -StorageAccountName $storageName -Force


"Installing IIS"

Set-AzureRmVMDscExtension -Version 2.21 `
    -ResourceGroupName $resourceGroup `
    -VMName $vmName `
    -ArchiveStorageAccountName $storageName `
    -ArchiveBlobName iisconf.ps1.zip `
    -AutoUpdate:$true `
    -ConfigurationName IISWebsite

"Installation done"            