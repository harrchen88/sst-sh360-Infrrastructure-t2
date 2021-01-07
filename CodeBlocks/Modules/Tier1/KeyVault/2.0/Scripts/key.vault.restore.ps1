<#
	.NOTES
		==============================================================================================
		Copyright(c) Microsoft Corporation. All rights reserved.

		File:		key.vault.restore.ps1

		Purpose:	Key Vault Restore Automation Script

		Version: 	1.0.0.0 - 1st May 2019 - Azure Virtual Datacenter Development Team
		==============================================================================================

	.SYNOPSIS
		Key Vault Restore Automation Script

	.DESCRIPTION
		Key Vault Restore Automation Script

		Deployment steps of the script are outlined below.
		1) Set Azure KeyVault Parameters
		2) Create temporary folder to download files
		3) Download files from Azure File Share
		4) Restore Key Vault Serects
			
	.PARAMETER keyVaultName
		Specify the Azure Key Vault Name parameter.

	.PARAMETER keyVaultResourceGroup
		Specify the Key Vault Resource Group Name parameter.

	.PARAMETER storageAccountName
		Specify the Storage Account Name parameter.
	
	.PARAMETER storageResourceGroup
		Specify the Storage Resource Group Name parameter.
	
	.PARAMETER fileshareName
		Specify the File Share Name parameter.

	.PARAMETER backupFolder
		Specify the Backup Folder parameter.

	.PARAMETER tempRestoreFolder
		Specify the Temp Restore Folder parameter.

	.EXAMPLE
		Default:
		C:\PS>.\key.vault.restore.ps1 `
			-keyVaultName <"keyVaultName"> `
			-keyVaultResourceGroup <"keyVaultResourceGroup> `
			-storageAccountName <"storageAccountName"> `
			-storageResourceGroup <"storageResourceGroup"> `
			-fileshareName <"fileshareName"> `
			-backupFolder <"backupFolder" `
			-tempRestoreFolder <"tempRestoreFolder">
#>

#Requires -Version 5
#Requires -Module AzureRM.KeyVault
#Requires -Module AzureRM.Storage
#Requires -Module Azure.Storage

[CmdletBinding()]
param
(
	[Parameter(Mandatory = $true)]
	[string]$keyVaultName,
	[Parameter(Mandatory = $true)]
	[string]$keyVaultResourceGroup,
	[Parameter(Mandatory = $true)]
	[string]$storageAccountName,
	[Parameter(Mandatory = $true)]
	[string]$storageResourceGroup,
	[Parameter(Mandatory = $true)]
	[string]$fileshareName,
	[Parameter(Mandatory = $true)]
	[string]$backupFolder,
	[string]$tempRestoreFolder = "$env:Temp\KeyVaultRestore"
)

#region - Create temporary folder to download files
if (test-path $tempRestoreFolder)
{
	$paramRemoveItem = @{
		Path    = $tempRestoreFolder
		Recurse = $true
		Force   = $true
	}
	Remove-Item @paramRemoveItem
}

$paramNewItem = @{
	ItemType = 'Directory'
	Force    = $true
	Path	 = $tempRestoreFolder
}
New-Item @paramNewItem | Out-Null

Write-Output "Starting download of backup to Azure Files"

$paramGetAzureRmStorageAccount = @{
	ResourceGroupName = $storageResourceGroup
	Name			  = $storageAccountName
}
$storageAccount = Get-AzureRmStorageAccount @paramGetAzureRmStorageAccount
#endregion

#region - Download files from Azure File Share
$paramGetAzureStorageFile = @{
	Context 	= $storageAccount.Context
	ShareName 	= $fileshareName
	Path    	= $backupFolderName
}
$backupFolderTest = Get-AzureStorageFile @paramGetAzureStorageFile

if (-not $backupFolderTest)
{
	Write-Error "Backup folder in Azure File Share Not Found"
	exit
}

$paramGetAzureStorageFile = @{
	ShareName = $fileshareName
	Path	  = $backupFolder
	Context   = $storageAccount.Context
}
$backupFiles = Get-AzureStorageFile @paramGetAzureStorageFile | Get-AzureStoragefile

foreach ($backupFile in $backupFiles)
{
	Write-Output "downloading $backupFolder\$($backupFile.name)"
	$paramGetAzureStorageFileContent = @{
		ShareName 	= $fileshareName
		Path	  	= "$backupFolder\$($backupFile.name)"
		Destination = "$tempRestoreFolder\$($backupFile.name)"
		Context   	= $storageAccount.Context
	}
	Get-AzureStorageFileContent @paramGetAzureStorageFileContent
}
#endregion

#region - Restore secrets to Key Vault
Write-Output "Starting Restore"

$secrets = get-childitem $tempRestoreFolder | where-object { $_ -match "^(secret-)" }
$certificates = get-childitem $tempRestoreFolder | where-object { $_ -match "^(certificate-)" }
$keys = get-childitem $tempRestoreFolder | where-object { $_ -match "^(key-)" }

foreach ($secret in $secrets)
{
	write-output "restoring $($secret.FullName)"
	$paramRestoreAzureKeyVaultSecret = @{
		VaultName = $keyVaultName
		InputFile = $secret.FullName
	}
	Restore-AzureKeyVaultSecret @paramRestoreAzureKeyVaultSecret
}

foreach ($certificate in $certificates)
{
	write-output "restoring $($certificate.FullName) "
	$paramRestoreAzureKeyVaultCertificate = @{
		VaultName = $keyVaultName
		InputFile = $certificate.FullName
	}
	Restore-AzureKeyVaultCertificate @paramRestoreAzureKeyVaultCertificate
}

foreach ($key in $keys)
{
	write-output "restoring $($key.FullName)  "
	$paramRestoreAzureKeyVaultKey = @{
		VaultName = $keyVaultName
		InputFile = $key.FullName
	}
	Restore-AzureKeyVaultKey @paramRestoreAzureKeyVaultKey
}

$paramRemoveItem = @{
	Path    = $tempRestoreFolder
	Recurse = $true
	Force   = $true
}
Remove-Item @paramRemoveItem

Write-Output "Restore Complete"
#endregion